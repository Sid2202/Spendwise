// import 'package:flutter/material.dart';
// import 'package:telephony/telephony.dart';
// import 'dart:io';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:string_similarity/string_similarity.dart';
// import 'dart:developer' as developer;

// void main() {
//   runApp(const Spendwise());
// }

// class Spendwise extends StatelessWidget {
//   const Spendwise({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Spendwise',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: SMS_money_trackerHome(),
//     );
//   }
// }

// class SMS_money_trackerHome extends StatefulWidget {
//   @override
//   _SMS_money_trackerState createState() => _SMS_money_trackerState();
// }

// class _SMS_money_trackerState extends State<SMS_money_trackerHome> {
//   final Telephony telephony = Telephony.instance;
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//   Map<String, List<SmsMessage>> _groupedMessages = {};

//   @override
//   void initState() {
//     super.initState();
//     _intializeNotificationsPlugin();
//     _listenForIncomingSMS();
//     _retrieveSMS();
//   }

//   void _intializeNotificationsPlugin() async{
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
//     const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin?.initialize(initializationSettings);
//   }

//   void _listenForIncomingSMS() {
//     telephony.listenIncomingSms(
//       onNewMessage: (SmsMessage message) {
//         final body = message.body?.toLowerCase() ?? '';

//         List<String> _bankKeywords = [
//           'debit', 'credit', 'withdraw', 'deposit', 'transfer', 'sent', 'receive', 'credited', 'debited', 'withdrawn', 'spent', 'paid', 'deduct', 'billed', 'withdrew', 'buy', 'purchase', 'expense', 'sent', 'deposited', 'received', 'added', 'credited', 'income', 'credited', 'deposit', 'credited', 'deposit'
//         ];
//         if (_bankKeywords.any((keyword) => body.contains(keyword))) {
//           _showNotification(message);
//         }

//         // if (body.contains('debit') || body.contains('credit') || body.contains('withdraw') || body.contains('deposit') || body.contains('transfer') || body.contains('sent') || body.contains('received')) {
//         //   _showNotification(message);
//         // }
//       },
//       onBackgroundMessage: _onBackgroundMessageHandler,
//     );
//   }

//   void _showNotification(SmsMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'sms_channel',               // Channel ID
//       'SMS Notifications',         // Channel Name
//       'Channel for SMS notifications', // Channel Description
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );

//     await flutterLocalNotificationsPlugin?.show(
//       0, // Notification ID
//       'New SMS from ${message.address}', // Notification title
//       message.body, // Notification body
//       platformChannelSpecifics,
//       payload: message.body, // Additional data (optional)
//     );
//   }

//   static void _onBackgroundMessageHandler(SmsMessage message) async {
//     final body = message.body?.toLowerCase() ?? '';
//     if (body.contains('credited') || body.contains('debited')) {
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//       const AndroidInitializationSettings initializationSettingsAndroid =
//           AndroidInitializationSettings('@mipmap/ic_launcher');

//       const InitializationSettings initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid,
//       );

//       await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//       const AndroidNotificationDetails androidPlatformChannelSpecifics =
//           AndroidNotificationDetails(
//         'sms_channel',               // Channel ID
//         'SMS Notifications',         // Channel Name
//         'Channel for SMS notifications', // Channel Description
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//       );

//       const NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//       );

//       await flutterLocalNotificationsPlugin.show(
//         0, // Notification ID
//         'New SMS from ${message.address}', // Notification title
//         message.body, // Notification body
//         platformChannelSpecifics,
//         payload: message.body, // Additional data (optional)
//       );
//     }
//   }

//   void _retrieveSMS() async {
    
//     // Request permission to read SMS
//     bool? permissionsGranted = await telephony.requestSmsPermissions;
//     if (permissionsGranted != null && permissionsGranted) {
      
//       int oneMonthAgo = DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch;

//       List<SmsMessage> messages = await telephony.getInboxSms(
//         columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
//       );

//       // List<SmsMessage> filteredMessages = messages.where((message) {
//       //   final body = message.body?.toLowerCase() ?? '';
//       //   final dateValid = message.date != null && message.date! >= oneMonthAgo;
//       //   List<String> _bankKeywords = [
//       //     'debit', 'credit', 'withdraw', 'deposit', 'transfer', 'sent', 'receive', 'credited', 'debited', 'withdrawn', 'spent', 'paid', 'deduct', 'billed', 'withdrew', 'buy', 'purchase', 'expense', 'sent', 'deposited', 'received', 'added', 'credited', 'income', 'credited', 'deposit', 'credited', 'deposit'
//       //   ];
//       //   final containsKeyword = body.contains('debit') || body.contains('credit') || body.contains('withdraw') || body.contains('deposit') || body.contains('transfer') || body.contains('sent');
//       //   return dateValid && containsKeyword;
//       // }).toList();

//       List<SmsMessage> filteredMessages = messages.where((message) {
//         final body = message.body?.toLowerCase() ?? '';
//         final dateValid = message.date != null && message.date! >= oneMonthAgo;
//         List<String> _bankKeywords = [
//           'debit', 'credit', 'withdraw', 'deposit', 'transfer', 'sent', 'receive', 'credited', 'debited', 'withdrawn'
//           // , 'spent', 'paid', 'deduct', 'billed', 'withdrew', 'buy', 'purchase', 'expense', 'sent', 'deposited', 'received', 'added', 'credited', 'income', 'credited', 'deposit', 'credited', 'deposit'
//         ];
//         if (_bankKeywords.any((keyword) => body.contains(keyword))) {
//           return dateValid;
//         }else{
//           return false;
//         }
        
//         // final containsKeyword = body.contains('debit') || body.contains('credit') || body.contains('withdraw') || body.contains('deposit') || body.contains('transfer') || body.contains('sent');
//         // return dateValid && containsKeyword;
//       }).toList();

//       _groupedMessages = {};

//       for (var message in filteredMessages) {
//         String sender = message.address ?? 'Unknown Sender';
//         //strip the string of hiphen and underscore and convert to lowercase
//         sender = sender.replaceAll('-', '').replaceAll('_', '').toLowerCase();

//        // if sender name contains more than 50 percent numbers, or contains more than 70% capital X, delete that message and sender.
//         int numbers = 0;
//         int capitalX = 0;

//         for (int i = 0; i < sender.length; i++){
//           if (sender[i].contains(RegExp(r'[0-9]'))){
//             numbers++;
//           }
//           if (sender[i].contains(RegExp(r'[X]'))){
//             capitalX++;
//           }
//         }
//         if (numbers/sender.length > 0.5 || capitalX/sender.length > 0.7){
//           continue;
//         }

//         // if the message body contains less than 2 integers, delete that message.
//         int integers = 0;
//         for (int i = 0; i < message.body!.length; i++){
//           if (message.body![i].contains(RegExp(r'[0-9]'))){
//             integers++;
//           }
//         }
//         if (integers < 2){
//           continue;
//         }


//         String lower_case_msg = message.body!.toLowerCase();
//         List<String> _spamKeywords = [
//           'refund', 'request', 'urgent', 'immediately', 'exciting', 'upcoming', 'win', 'congratulations', 'claim', 'prize', 'offer', 'free', 'discount', 'overdue', 'update', 'login', 'password', 'otp', 'code', 'download', 'install', 'subscribe', 'unsubscribe', 'rate', 'review', 'like', 'share', 'forward', 'invite', 'join', 'register', 'signup', 'login', 'logout', 'delete', 'remove', 'uninstall', 'upgrade', 'update', 'change', 'edit', 'modify', 'add', 'create', 'reminder'
//         ];

//         if (_spamKeywords.any((keyword) => lower_case_msg.contains(keyword))) {
//           continue;
//         }

//         // identify debit or credit

//         List<String> _debitKeywords = [
//           'debit', 'withdrawn', 'spent', 'paid', 'deduct', 'billed', 'withdrew', 'buy', 'purchase', 'expense', 'sent'
//         ];

//         List<String> _creditKeywords = [
//           'credit', 'deposited', 'received', 'added', 'credited', 'income', 'credited', 'deposit', 'credited', 'deposit', 'receive'
//         ];

//         String transactionType = '';
//         if (_debitKeywords.any((keyword) => lower_case_msg.contains(keyword))){
//           transactionType = 'debit';
//         } else if (_creditKeywords.any((keyword) => lower_case_msg.contains(keyword))){
//           transactionType = 'credit';
//         } else {
//           continue;
//         }

//         // find bank account number and bank name
//         // identify amount, date, time, transaction type(debit or credit), receiver

//         // get notification on the phone
//         //Lets do this tomorrow babe!





//         String bestMatchGroup = '';
//         int bestMatchLength = 0;
        
//         // Check if the sender is already in the map
//         bool foundGroup = false;
//         for (var group in _groupedMessages.keys) {
//           String commonSubstring = _longestCommonSubstring(group, sender);
//           if (commonSubstring.length >=3 && commonSubstring.length > bestMatchLength){
//             bestMatchGroup = group;
//             bestMatchLength = commonSubstring.length;
//           }
//         }

//         if (bestMatchGroup.isNotEmpty){
//           List<SmsMessage>? existingMessages = _groupedMessages.remove(bestMatchGroup);
//           String newGroupName = _longestCommonSubstring(bestMatchGroup, sender);
//           _groupedMessages[newGroupName] = (existingMessages ?? [])..add(message);
//         } else {
//           _groupedMessages[sender] = [message];
//         }

//       }

//       setState(() {
//         _groupedMessages = _groupedMessages;
//       });
//     } else {
//       setState(() {
//         _groupedMessages = {};
//       }); 
//     }
//   }

//   String _longestCommonSubstring(String str1, String str2) {
//     int maxLen = 0;
//     String result = '';

//     for (int i = 0; i < str1.length; i++) {
//       for (int j = i + 3; j <= str1.length; j++) {
//         String substring = str1.substring(i, j);
//         if (str2.contains(substring) && substring.length > maxLen) {
//           maxLen = substring.length;
//           result = substring;
//         }
//       }
//     }

//     return result;
//   }

//   void _scrap_out_messages(Map<String, List<SmsMessage>> groupedMessages){
//     // Scrap out messages from the grouped messages. 

//     // if sender name contains more than 50 percent numbers, or contains more than 70% capital X, delete that sender.
//     for (var group in groupedMessages.keys){
//       String sender = group;
//       int numbers = 0;
//       int capitalX = 0;
//       for (int i = 0; i < sender.length; i++){
//         if (sender[i].contains(RegExp(r'[0-9]'))){
//           numbers++;
//         }
//         if (sender[i].contains(RegExp(r'[X]'))){
//           capitalX++;
//         }
//       }
//       if (numbers/sender.length > 0.5 || capitalX/sender.length > 0.7){
//         groupedMessages.remove(group);
//       }
//     }
//     setState(() {
//       _groupedMessages = _groupedMessages;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Spendwise'),
//       ),
//       body: _groupedMessages.isEmpty
//           ? Center(child: Text('No relevant messages found or permissions not granted.'))
//           : ListView(
//               children: _groupedMessages.entries.map((entry) {
//                 String sender = entry.key;
//                 List<SmsMessage> messages = entry.value;

//                 return ExpansionTile(
//                   title: Text(sender),
//                   children: messages.map((message) {
//                     DateTime date = DateTime.fromMillisecondsSinceEpoch(message.date ?? 0);
//                     return ListTile(
//                       title: Text(message.body ?? ''),
//                       subtitle: Text(date.toLocal().toString()),
//                     );
//                   }).toList(),
//                 );
//               }).toList(),
//             ),
          
//     );
//   }

// }


import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const Nexus());
}

