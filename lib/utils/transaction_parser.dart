import 'package:telephony/telephony.dart';
import '../models/transaction.dart';

class TransactionParser {
  static List<String> debitKeywords = [
    'debit', 'withdrawn', 'spent', 'paid', 'deduct', 'billed', 'withdrew', 'buy', 'purchase', 'expense', 'sent'
  ];

  static List<String> creditKeywords = [
    'credit', 'deposited', 'received', 'added', 'credited', 'income', 'deposit', 'receive'
  ];

  static List<String> spamKeywords = [
    'refund', 'request', 'requested', 'urgent', 'immediately', 'exciting', 'upcoming', 'win', 'congratulations', 'claim', 'prize', 'offer', 'free', 'discount', 'overdue', 'update', 'password', 'otp', 'download', 'install', 'subscribe', 'unsubscribe', 'rate', 'review', 'like', 'share', 'forward', 'invite', 'join', 'register', 'signup', 'login', 'logout', 'delete', 'remove', 'uninstall', 'upgrade', 'update', 'change', 'edit', 'modify', 'add', 'create', 'reminder', 'renew', 'due', 'missed', 'recharge'
  ];

  static Transaction? parseTransaction(SmsMessage message) {
    String lowerCaseMsg = message.body!.toLowerCase();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(message.date ?? 0);

    String transactionType = '';
    if (debitKeywords.any((keyword) => lowerCaseMsg.contains(keyword))) {
      transactionType = 'debit';
    } else if (creditKeywords.any((keyword) => lowerCaseMsg.contains(keyword))) {
      transactionType = 'credit';
    } else {
      return null;
    }

    // if the message body contains less than 2 integers, delete that message.
    int integers = 0;
    for (int i = 0; i < message.body!.length; i++) {
      if (message.body![i].contains(RegExp(r'[0-9]'))) {
        integers++;
      }
    }
    if (integers < 2) {
      return null;
    }

    // if the message body contains spam keywords, delete that message.
    if (RegExp(r'\b(' + spamKeywords.join('|') + r')\b').hasMatch(lowerCaseMsg)) {
      return null;
    }

    // Implement logic to extract bank name

    // String bankName = _extractBankName(message.address ?? 'Unknown Sender', lowerCaseMsg);
    // String? accountNumber = _extractAccountNumber(lowerCaseMsg);
    double? amount = _extractAmount(lowerCaseMsg);
    double? balance = _extractBalance(lowerCaseMsg);

    // if unknown sender or unknown amount, delete that message.
    // if (bankName == 'Unknown Sender' || amount == null) {
    //   return null;
    // }

    return Transaction(
      bankName: '',
      transactionType: transactionType,
      accountNumber: '',
      amount: amount,
      balance: balance,
      date: date,
      originalMessage: message.body ?? '',
    );
  }
  static double? _extractAmount(String message) {
    // Implement logic to extract transaction amount
    // This is a placeholder implementation
    RegExp amountRegex = RegExp(r'(?:by\s*)?(?:rs\.?|inr)\s*([\d,]+(?:\.\d{1,2})?)');
    var match = amountRegex.firstMatch(message);

    if (match != null) {
      String amountStr = match.group(1)!;
      // If the amount contains a comma, return null
      if (amountStr.contains(',')) {
        return null;
      }
      return double.tryParse(amountStr);
    }
    return null;
  }

  static double? _extractBalance(String message) {
    // Implement logic to extract account balance
    // This is a placeholder implementation
    RegExp balanceRegex = RegExp(r'(?:balance|bal).*?(?:rs\.?|inr)\s*(\d+(?:\.\d{1,2})?)');
    var match = balanceRegex.firstMatch(message);
    return match != null ? double.tryParse(match.group(1)!) : null;
  }
}