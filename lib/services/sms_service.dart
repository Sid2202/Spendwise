import 'dart:math';

import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import '../utils/transaction_parser.dart';
import '../models/transaction.dart';
import 'notification_service.dart';
import '../models/groupedTransaction.dart';

class SMSService {
  static final Telephony telephony = Telephony.instance;
  // static final Map<String, List<Transaction>> _groupedTransactions = {};
  static final Map<String, List<GroupedTransaction>> _groupedTransactions = {};

  static void listenForIncomingSMS() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        final body = message.body?.toLowerCase() ?? '';
        if (TransactionParser.debitKeywords.any((keyword) => body.contains(keyword)) || 
            TransactionParser.creditKeywords.any((keyword) => body.contains(keyword))) {
          NotificationService.showNotification(
            message.address ?? 'Unknown Sender',
            message.body ?? 'No message body',
          );
          _processNewMessage(message);
        }
      },
      onBackgroundMessage: _onBackgroundMessageHandler,
    );
  }

  static Future<Map<String, List<GroupedTransaction>>> retrieveTransactions(String selectedMonth) async {
    bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      int selectedMonthTimestamp = _getMonthTimestamp(selectedMonth);
      // int oneMonthAgo = DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch;
      List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
      );
      // there is no point in clearing the existing data
      _groupedTransactions.clear();

      for (var message in messages) {
        if (message.date != null && _isMessageInSelectedMonth(message.date!, selectedMonthTimestamp)) {
          _processNewMessage(message);
        }
      }
    }
    return _groupedTransactions;
  }

  static int _getMonthTimestamp (String selectedMonth) {
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    int monthNumber = months.indexOf(selectedMonth) + 1;
    DateTime date = DateTime(DateTime.now().year, monthNumber);
    return date.millisecondsSinceEpoch;
  }

  static bool _isMessageInSelectedMonth(int messageTimestamp, int selectedMonthTimestamp) {
    DateTime messageDate = DateTime.fromMillisecondsSinceEpoch(messageTimestamp);
    DateTime selectedMonthDate = DateTime.fromMillisecondsSinceEpoch(selectedMonthTimestamp);
    return messageDate.year == selectedMonthDate.year && messageDate.month == selectedMonthDate.month;
  }

  static void _processNewMessage(SmsMessage message) {
    String bankName = _extractBankName(message.address ?? '', message.body ?? '');
    String? accountNumber = _extractAccountNumber(message.body ?? '');
    // print('Bank Name: $bankName, Account Number: $accountNumber');

    if (bankName == 'Unknown Sender' && accountNumber == null) {
      return;
    }


    Transaction? transaction = TransactionParser.parseTransaction(message);
    if (transaction != null) {
      transaction = Transaction(
        bankName: bankName,
        transactionType: transaction.transactionType,
        accountNumber: accountNumber,
        amount: transaction.amount,
        balance: transaction.balance,
        date: transaction.date,
        originalMessage: transaction.originalMessage,
      );
      List<GroupedTransaction>? existingGroupedTransactions = _groupedTransactions[accountNumber ?? bankName];
      if (existingGroupedTransactions != null) {
        existingGroupedTransactions.first.transactions.add(transaction);
      } else {
        GroupedTransaction groupedTransaction = GroupedTransaction(
          bankName: bankName,
          accountNumber: accountNumber,
          transactions: [transaction],
        );
        // _groupedTransactions.putIfAbsent(accountNumber ? bankName : accountNumber, () => []).add(groupedTransaction);
        if (_groupedTransactions.containsKey(accountNumber ?? bankName)) {
          _groupedTransactions[accountNumber ?? bankName]!.add(groupedTransaction);
        } else {
          _groupedTransactions[accountNumber ?? bankName] = [groupedTransaction];
        }
      }
    }
  }

  static String _extractBankName(String sender, String message) {
    sender = sender.toUpperCase();
    //split the sender with - and choose the string which has more length
    sender = sender.split('-').reduce((a, b) => a.length > b.length ? a : b);
    //split the sender with _ and choose the string which has more length
    sender = sender.split('_').reduce((a, b) => a.length > b.length ? a : b);
    
    // if sender name contains more than 50 percent numbers, or contains more than 70% capital X, delete that message and sender.
    int numbers = 0;
    int capitalX = 0;
    for (int i = 0; i < sender.length; i++) {
      if (sender[i].contains(RegExp(r'[0-9]'))) {
        numbers++;
      }
      if (sender[i].contains(RegExp(r'[X]'))) {
        capitalX++;
      }
    }
    if (numbers / sender.length > 0.5 || capitalX / sender.length > 0.7) {
      sender = 'Unknown Sender';
    }


    // if _extractAmount is null, delete that message and sender.
    // if (_extractAmount(message) == null) {
    //   sender = 'Unknown Sender';
    // }

    return sender;
  }

  static String? _extractAccountNumber(String message) {
    RegExp accountRegex = RegExp(r'(?:account|a/c|ac).*?x\s*(\d+)');
    var match = accountRegex.firstMatch(message);
    return match?.group(1);
  }


  static void _onBackgroundMessageHandler(SmsMessage message) async {
    final body = message.body?.toLowerCase() ?? '';
    if (TransactionParser.debitKeywords.any((keyword) => body.contains(keyword)) || 
        TransactionParser.creditKeywords.any((keyword) => body.contains(keyword))) {
      NotificationService.showNotification(
        message.address ?? 'Unknown Sender',
        message.body ?? 'No message content'
      );
    }
  }
}