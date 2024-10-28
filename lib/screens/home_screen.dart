
// import 'package:telephony/telephony.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:flutter/material.dart';
// import '../services/sms_service.dart';
// import '../services/notification_service.dart';
// import '../models/transaction.dart';

// class SMS_money_trackerHome extends StatefulWidget {
//   @override
//   _SMS_money_trackerState createState() => _SMS_money_trackerState();
// }

// class _SMS_money_trackerState extends State<SMS_money_trackerHome> {
//   final Telephony telephony = Telephony.instance;
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//   Map<String, List<Transaction>> _groupedTransactions = {};

//   @override
//   void initState() {
//     super.initState();
//     NotificationService.initialize();
//     SMSService.listenForIncomingSMS();
//     _retrieveTransactions();
//   }

//   void _retrieveTransactions() async {
//     var transactions = await SMSService.retrieveTransactions();
//     setState(() {
//       _groupedTransactions = transactions;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Spendwise'),
//       ),
//       body: _groupedTransactions.isEmpty
//           ? Center(child: Text('No relevant transactions found or permissions not granted.'))
//           : ListView(
//               children: _groupedTransactions.entries.map((entry) {
//                 String bankName = entry.key;
//                 List<Transaction> transactions = entry.value;

//                 return ExpansionTile(
//                   title: Text(bankName),
//                   children: transactions.map((transaction) {
//                     return ListTile(
//                       title: Text('${transaction.transactionType.toUpperCase()}: ${transaction.amount != null ? 'Rs. ${transaction.amount!.toStringAsFixed(2)}' : 'Unknown amount'}'),
//                       // subtitle: Text(transaction.date.toLocal().toString()),
//                       subtitle: Text(transaction.originalMessage),
                      
                      
//                     );
//                   }).toList(),
//                 );
//               }).toList(),
//             ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:telephony/telephony.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../services/sms_service.dart';
// import '../services/notification_service.dart';
// import '../models/transaction.dart';
// import 'package:intl/intl.dart';

// class SpendwiseHome extends StatefulWidget {
//   @override
//   _SpendwiseState createState() => _SpendwiseState();
// }

// class _SpendwiseState extends State<SpendwiseHome> {
//   final Telephony telephony = Telephony.instance;
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//   Map<String, List<Transaction>> _groupedTransactions = {};

//   @override
//   void initState() {
//     super.initState();
//     NotificationService.initialize();
//     SMSService.listenForIncomingSMS();
//     _retrieveTransactions();
//   }

//   void _retrieveTransactions() async {
//     var transactions = await SMSService.retrieveTransactions();
//     setState(() {
//       _groupedTransactions = transactions;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(
//           '💸 Spendwise',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//         elevation: 0,
//       ),
//       body: _groupedTransactions.isEmpty
//           ? EmptyStateWidget()
//           : TransactionListView(groupedTransactions: _groupedTransactions),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _retrieveTransactions,
//         child: Icon(Icons.refresh),
//         backgroundColor: Colors.deepPurple,
//       ),
//     );
//   }
// }

// class EmptyStateWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox, size: 80, color: Colors.grey),
//           SizedBox(height: 16),
//           Text(
//             'No transactions yet!',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Text("We're waiting for your first SMS 📱"),
//         ],
//       ),
//     );
//   }
// }

// class TransactionListView extends StatelessWidget {
//   final Map<String, List<Transaction>> groupedTransactions;

//   const TransactionListView({Key? key, required this.groupedTransactions}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: groupedTransactions.length,
//       itemBuilder: (context, index) {
//         String bankName = groupedTransactions.keys.elementAt(index);
//         List<Transaction> transactions = groupedTransactions.values.elementAt(index);
//         return BankCard(bankName: bankName, transactions: transactions);
//       },
//     );
//   }
// }

// class BankCard extends StatelessWidget {
//   final String bankName;
//   final List<Transaction> transactions;

//   const BankCard({Key? key, required this.bankName, required this.transactions}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: EdgeInsets.only(bottom: 16),
//       child: ExpansionTile(
//         title: Text(
//           bankName,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         leading: Icon(Icons.account_balance, color: Colors.deepPurple),
//         children: [
//           ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: transactions.length,
//             itemBuilder: (context, index) {
//               return TransactionTile(transaction: transactions[index]);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TransactionTile extends StatelessWidget {
//   final Transaction transaction;

//   const TransactionTile({Key? key, required this.transaction}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     IconData icon;
//     Color color;
//     if (transaction.transactionType.toLowerCase() == 'debit') {
//       icon = Icons.arrow_downward;
//       color = Colors.red;
//     } else {
//       icon = Icons.arrow_upward;
//       color = Colors.green;
//     }

//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: color.withOpacity(0.1),
//         child: Icon(icon, color: color),
//       ),
//       title: Text(
//         transaction.amount != null
//             ? 'Rs. ${transaction.amount!.toStringAsFixed(2)}'
//             : 'Unknown amount',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         DateFormat('MMM d, y').format(transaction.date.toLocal()),
//         style: TextStyle(color: Colors.grey[600]),
//       ),
//       trailing: Icon(Icons.chevron_right),
//       onTap: () {
//         showModalBottomSheet(
//           context: context,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           builder: (context) => TransactionDetails(transaction: transaction),
//         );
//       },
//     );
//   }
// }

// class TransactionDetails extends StatelessWidget {
//   final Transaction transaction;

//   const TransactionDetails({Key? key, required this.transaction}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Transaction Details',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           DetailRow(
//             title: 'Type',
//             value: transaction.transactionType.toUpperCase(),
//           ),
//           DetailRow(
//             title: 'Amount',
//             value: transaction.amount != null
//                 ? 'Rs. ${transaction.amount!.toStringAsFixed(2)}'
//                 : 'Unknown amount',
//           ),
//           DetailRow(
//             title: 'Date',
//             value: DateFormat('MMMM d, y HH:mm').format(transaction.date.toLocal()),
//           ),
//           DetailRow(title: 'Message', value: transaction.originalMessage),
//         ],
//       ),
//     );
//   }
// }

// class DetailRow extends StatelessWidget {
//   final String title;
//   final String value;

//   const DetailRow({Key? key, required this.title, required this.value})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:money_tracker/models/groupedTransaction.dart';
// import 'package:telephony/telephony.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../services/sms_service.dart';
// import '../services/notification_service.dart';
// import '../models/transaction.dart';
// import 'package:intl/intl.dart';

// class SMS_money_trackerHome extends StatefulWidget {
//   @override
//   _SMS_money_trackerState createState() => _SMS_money_trackerState();
// }

// class _SMS_money_trackerState extends State<SMS_money_trackerHome> {
//   final Telephony telephony = Telephony.instance;
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//   Map<String, List<GroupedTransaction>> _groupedTransactions = {};

//   @override
//   void initState() {
//     super.initState();
//     NotificationService.initialize();
//     SMSService.listenForIncomingSMS();
//     _retrieveTransactions();
//   }

//   void _retrieveTransactions() async {
//     var transactions = await SMSService.retrieveTransactions();
//     setState(() {
//       _groupedTransactions = transactions;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: _groupedTransactions.isEmpty
//           ? EmptyStateWidget()
//           : CreativeFinanceHome(groupedTransactions: _groupedTransactions),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _retrieveTransactions,
//         child: Icon(Icons.refresh),
//         backgroundColor: Colors.deepPurple,
//       ),
//     );
//   }
// }

// class EmptyStateWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox, size: 80, color: Colors.grey),
//           SizedBox(height: 16),
//           Text(
//             'No transactions yet!',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Text('We\'re waiting for your first SMS 📱'),
//         ],
//       ),
//     );
//   }
// }

// class CreativeFinanceHome extends StatelessWidget {
//   final Map<String, List<GroupedTransaction>> groupedTransactions;

//   CreativeFinanceHome({required this.groupedTransactions});

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           expandedHeight: 50,
//           floating: false,
//           pinned: true,
//           flexibleSpace: FlexibleSpaceBar(
//             title: Text('Spendwise', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//             background: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Colors.deepPurple, Colors.blue],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Your Banks',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Container(
//             height: 200,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: groupedTransactions.length,
//               itemBuilder: (context, index) {
//                 // String bankName = groupedTransactions.keys.elementAt(index);
//                 // String accountNumber = groupedTransactions.keys.elementAt(index);
//                 List<GroupedTransaction> groupedTransactionsForAccount = groupedTransactions.values.elementAt(index);
//                 GroupedTransaction groupedTransaction = groupedTransactionsForAccount.first;
//                 return BankCard(
//                   bankName: groupedTransaction.bankName, 
//                   transactions: groupedTransaction.transactions, 
//                   accountNumber: groupedTransaction.accountNumber ?? 'Unknown Account Number',
//                 );
//               },
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Recent Transactions',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               List<Transaction> allTransactions = groupedTransactions.values
//                 .expand((groupedTransactions) => groupedTransactions)
//                 .expand((groupedTransactions) => groupedTransactions.transactions)
//                 .toList();
//               allTransactions.sort((a, b) => b.date.compareTo(a.date));
//               return TransactionTile(transaction: allTransactions[index]);
//             },
//             childCount: groupedTransactions.values.expand((i) => i).length,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class BankCard extends StatelessWidget {
//   final String bankName;
//   final List<Transaction> transactions;
//   final String accountNumber;
  
//   const BankCard({Key? key, required this.bankName, required this.transactions, required this.accountNumber}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => BankTransactionsScreen(bankName: bankName, transactions: transactions),
//           ),
//         );
//       },
//       child: Container(
//         width: 160,
//         margin: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.purple, Colors.deepPurple],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.account_balance, color: Colors.white, size: 48),
//             SizedBox(height: 8),
//             Text(
//               bankName,
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               accountNumber,
//               style: TextStyle(color: Colors.white70),
//             ),
//             SizedBox(height: 8),
//             Text(
//               '${transactions.length} transactions',
//               style: TextStyle(color: Colors.white70),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BankTransactionsScreen extends StatelessWidget {
//   final String bankName;
//   final List<Transaction> transactions;

//   const BankTransactionsScreen({Key? key, required this.bankName, required this.transactions}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(bankName, style: TextStyle(fontWeight: FontWeight.bold)),
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.purple, Colors.deepPurple],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) => TransactionTile(transaction: transactions[index]),
//               childCount: transactions.length,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TransactionTile extends StatelessWidget {
//   final Transaction transaction;

//   const TransactionTile({Key? key, required this.transaction}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     IconData icon;
//     Color color;
//     if (transaction.transactionType.toLowerCase() == 'debit') {
//       icon = Icons.arrow_downward;
//       color = Colors.red;
//     } else {
//       icon = Icons.arrow_upward;
//       color = Colors.green;
//     }

//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: color.withOpacity(0.1),
//         child: Icon(icon, color: color),
//       ),
//       title: Text(
//         '${transaction.amount != null ? 'Rs. ${transaction.amount!.toStringAsFixed(2)}' : 'Unknown amount'}',
//         style: TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         DateFormat('MMM d, y').format(transaction.date.toLocal()),
//         style: TextStyle(color: Colors.grey[600]),
//       ),
//       trailing: Icon(Icons.chevron_right),
//       onTap: () {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           backgroundColor: Colors.transparent,
//           builder: (context) => DraggableScrollableSheet(
//             initialChildSize: 0.9,
//             minChildSize: 0.5,
//             maxChildSize: 0.9,
//             builder: (_, controller) => TransactionDetails(transaction: transaction, scrollController: controller),
//           ),
//         );
//       },
//     );
//   }
// }

// class TransactionDetails extends StatelessWidget {
//   final Transaction transaction;
//   final ScrollController scrollController;

//   const TransactionDetails({Key? key, required this.transaction, required this.scrollController}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: ListView(
//         controller: scrollController,
//         padding: EdgeInsets.all(20),
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               margin: EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           Text(
//             'Transaction Details',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           DetailRow(title: 'Type', value: transaction.transactionType.toUpperCase()),
//           DetailRow(
//             title: 'Amount',
//             value: transaction.amount != null
//                 ? 'Rs. ${transaction.amount!.toStringAsFixed(2)}'
//                 : 'Unknown amount',
//           ),
//           DetailRow(
//             title: 'Date',
//             value: DateFormat('MMMM d, y HH:mm').format(transaction.date.toLocal()),
//           ),
//           DetailRow(title: 'Message', value: transaction.originalMessage),
//         ],
//       ),
//     );
//   }
// }

// class DetailRow extends StatelessWidget {
//   final String title;
//   final String value;

//   const DetailRow({Key? key, required this.title, required this.value}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               title,
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
//             ),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WealthifyHome extends StatefulWidget {
//   @override
//   _WealthifyState createState() => _WealthifyState();
// }

// class _WealthifyState extends State<WealthifyHome> {
//   final Telephony telephony = Telephony.instance;
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//   Map<String, List<GroupedTransaction>> _groupedTransactions = {};

//   @override
//   void initState() {
//     super.initState();
//     NotificationService.initialize();
//     SMSService.listenForIncomingSMS();
//     _retrieveTransactions();
//   }

//   void _retrieveTransactions() async {
//     var transactions = await SMSService.retrieveTransactions();
//     setState(() {
//       _groupedTransactions = transactions;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1A1A2E),
//       body: _groupedTransactions.isEmpty
//           ? EmptyStateWidget()
//           : WealthifyDashboard(groupedTransactions: _groupedTransactions),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _retrieveTransactions,
//         child: Icon(Icons.refresh, color: Colors.white),
//         backgroundColor: Color(0xFF4DD0E1),
//       ),
//     );
//   }
// }

// class EmptyStateWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.inbox, size: 80, color: Colors.white),
//           SizedBox(height: 16),
//           Text(
//             'No transactions yet!',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           Text('We\'re waiting for your first SMS 📱', style: TextStyle(color: Colors.white70)),
//         ],
//       ),
//     );
//   }
// }

// class WealthifyDashboard extends StatelessWidget {
//   final Map<String, List<GroupedTransaction>> groupedTransactions;

//   WealthifyDashboard({required this.groupedTransactions});

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           expandedHeight: 100,
//           floating: false,
//           pinned: true,
//           flexibleSpace: FlexibleSpaceBar(
//             title: Text('Wealthify', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//             background: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFF4DD0E1), Color(0xFF1976D2)],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Your Banks',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Container(
//             height: 200,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: groupedTransactions.length,
//               itemBuilder: (context, index) {
//                 List<GroupedTransaction> groupedTransactionsForAccount = groupedTransactions.values.elementAt(index);
//                 GroupedTransaction groupedTransaction = groupedTransactionsForAccount.first;
//                 return BankCard(
//                   bankName: groupedTransaction.bankName, 
//                   transactions: groupedTransaction.transactions, 
//                   accountNumber: groupedTransaction.accountNumber ?? 'Unknown Account Number',
//                 );
//               },
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Recent Transactions',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//         ),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               List<Transaction> allTransactions = groupedTransactions.values
//                 .expand((groupedTransactions) => groupedTransactions)
//                 .expand((groupedTransactions) => groupedTransactions.transactions)
//                 .toList();
//               allTransactions.sort((a, b) => b.date.compareTo(a.date));
//               return TransactionTile(transaction: allTransactions[index]);
//             },
//             childCount: groupedTransactions.values.expand((i) => i).length,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class BankCard extends StatelessWidget {
//   final String bankName;
//   final List<Transaction> transactions;
//   final String accountNumber;
  
//   const BankCard({Key? key, required this.bankName, required this.transactions, required this.accountNumber}) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => BankTransactionsScreen(bankName: bankName, transactions: transactions),
//           ),
//         );
//       },
//       child: Container(
//         width: 160,
//         margin: EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF8E44AD), Color(0xFF4DD0E1)],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.account_balance, color: Colors.white, size: 48),
//             SizedBox(height: 8),
//             Text(
//               bankName,
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               accountNumber,
//               style: TextStyle(color: Colors.white70),
//             ),
//             SizedBox(height: 8),
//             Text(
//               '${transactions.length} transactions',
//               style: TextStyle(color: Colors.white70),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BankTransactionsScreen extends StatelessWidget {
//   final String bankName;
//   final List<Transaction> transactions;

//   BankTransactionsScreen({required this.bankName, required this.transactions});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$bankName Transactions'),
//         backgroundColor: Color(0xFF1A1A2E),
//       ),
//       body: transactions.isEmpty
//           ? Center(
//               child: Text(
//                 'No transactions found for $bankName',
//                 style: TextStyle(color: Colors.white),
//               ),
//             )
//           : ListView.builder(
//               itemCount: transactions.length,
//               itemBuilder: (context, index) {
//                 final transaction = transactions[index];
//                 IconData icon;
//                 Color color;
//                 if (transaction.transactionType.toLowerCase() == 'debit') {
//                   icon = Icons.arrow_downward;
//                   color = Colors.red;
//                 } else {
//                   icon = Icons.arrow_upward;
//                   color = Colors.green;
//                 }
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: color.withOpacity(0.1),
//                     child: Icon(icon, color: color),
//                   ),
//                   title: Text(
//                     'Rs. ${transaction.amount != null ? transaction.amount!.toStringAsFixed(2) : 'Unknown'}',
//                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                   subtitle: Text(
//                     DateFormat('MMM d, y').format(transaction.date.toLocal()),
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   trailing: Icon(Icons.chevron_right, color: Colors.white),
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       isScrollControlled: true,
//                       backgroundColor: Colors.transparent,
//                       builder: (context) => TransactionDetails(transaction: transaction),
//                     );
//                   },
//                 );
//               },
//             ),
//       backgroundColor: Color(0xFF1A1A2E),
//     );
//   }
// }

// class TransactionTile extends StatelessWidget {
//   final Transaction transaction;

//   const TransactionTile({Key? key, required this.transaction}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     IconData icon;
//     Color color;
//     if (transaction.transactionType.toLowerCase() == 'debit') {
//       icon = Icons.arrow_downward;
//       color = Colors.red;
//     } else {
//       icon = Icons.arrow_upward;
//       color = Colors.green;
//     }

//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: color.withOpacity(0.1),
//         child: Icon(icon, color: color),
//       ),
//       title: Text(
//         '${transaction.amount != null ? 'Rs. ${transaction.amount!.toStringAsFixed(2)}' : 'Unknown amount'}',
//         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//       ),
//       subtitle: Text(
//         DateFormat('MMM d, y').format(transaction.date.toLocal()),
//         style: TextStyle(color: Colors.grey[600]),
//       ),
//       trailing: Icon(Icons.chevron_right, color: Colors.white),
//       onTap: () {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           backgroundColor: Colors.transparent,
//           builder: (context) => TransactionDetails(transaction: transaction),
//         );
//       },
//     );
//   }
// }

// class TransactionDetails extends StatelessWidget {
//   final Transaction transaction;

//   const TransactionDetails({Key? key, required this.transaction}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFF1A1A2E),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 margin: EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             Text(
//               'Transaction Details',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//             SizedBox(height: 20),
//             DetailRow(title: 'Type', value: transaction.transactionType.toUpperCase()),
//             DetailRow(
//               title: 'Amount',
//               value: transaction.amount != null
//                   ? 'Rs. ${transaction.amount!.toStringAsFixed(2)}'
//                   : 'Unknown amount',
//             ),
//             DetailRow(
//               title: 'Date',
//               value: DateFormat('MMMM d, y HH:mm').format(transaction.date.toLocal()),
//             ),
//             DetailRow(title: 'Message', value: transaction.originalMessage),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DetailRow extends StatelessWidget {
//   final String title;
//   final String value;

//   const DetailRow({Key? key, required this.title, required this.value}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               title,
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
//             ),
//           ),
//           Expanded(
//             child: Text(value, style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:money_tracker/models/groupedTransaction.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/sms_service.dart';
import '../services/notification_service.dart';
import '../models/transaction.dart';
import '../layouts/dashboard.dart';
import '../layouts/transactions.dart';
import 'package:intl/intl.dart';
import '../components/header.dart';
import 'package:fl_chart/fl_chart.dart';


class NexusHome extends StatefulWidget {
  @override
  _NexusHomeState createState() => _NexusHomeState();
}

class _NexusHomeState extends State<NexusHome> {
  final Telephony telephony = Telephony.instance;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  Map<String, List<GroupedTransaction>> _groupedTransactions = {};
  int _selectedIndex = 0;
  String _selectedMonth = DateFormat('MMMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    NotificationService.initialize();
    SMSService.listenForIncomingSMS();
    _retrieveTransactions(_selectedMonth);
  }

  void _retrieveTransactions(String selectedMonth) async {
    var transactions = await SMSService.retrieveTransactions(selectedMonth);
    setState(() {
      _groupedTransactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 254, 255),
      body: _groupedTransactions.isEmpty
          ? EmptyStateWidget()
          : Column(
            children: [
              Header(
                name: 'Sid',
                isDarkTheme: false,
                onThemeToggle: () {
                  // Implement theme toggle
                },
              ),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    Transactions(groupedTransactions: _groupedTransactions),
                    Dashboard(groupedTransactions: _groupedTransactions),
                    InsightsTab(),
                    GoalsTab(),
                  ],
                ),
              ),
            ],
          ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Color(0xFF16213E),
          selectedItemColor: Color(0xFF4DD0E1),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Transactions'),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Insights'),
            BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
          ],
        ),
    
    );
  }
}
























class EmptyStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet, size: 80, color: Color(0xFF4DD0E1)),
          SizedBox(height: 16),
          Text(
            'Welcome to Zenith!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            'We\'re waiting for your first transaction.',
            style: TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Implement onboarding or manual transaction entry
            },
            child: Text('Get Started'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4DD0E1),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class InsightsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Insights', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Color(0xFF16213E),
          floating: true,
          snap: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Spending Breakdown',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16),
                SpendingBreakdownChart(),
                SizedBox(height: 32),
                Text(
                  'Savings Tip',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16),
                Card(
                  color: Color(0xFF16213E),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Try the 50/30/20 rule: Allocate 50% of your income to needs, 30% to wants, and 20% to savings and debt repayment.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SpendingBreakdownChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.red,
              value: 35,
              title: '35%',
              radius: 50,
              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              color: Colors.blue,
              value: 25,
              title: '25%',
              radius: 50,
              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              color: Colors.green,
              value: 20,
              title: '20%',
              radius: 50,
              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              color: Colors.yellow,
              value: 15,
              title: '15%',
              radius: 50,
              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            PieChartSectionData(
              color: Colors.purple,
              value: 5,
              title: '5%',
              radius: 50,
              titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
          sectionsSpace: 0,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}

class GoalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Financial Goals', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Color(0xFF16213E),
          floating: true,
          snap: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GoalCard(
                  title: 'New Laptop',
                  currentAmount: 80000,
                  targetAmount: 100000,
                ),
                SizedBox(height: 16),
                GoalCard(
                  title: 'Emergency Fund',
                  currentAmount: 50000,
                  targetAmount: 100000,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Implement add new goal functionality
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add New Goal'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4DD0E1),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final double currentAmount;
  final double targetAmount;

  GoalCard({required this.title, required this.currentAmount, required this.targetAmount});

  @override
  Widget build(BuildContext context) {
    double progress = currentAmount / targetAmount;

    return Card(
      color: Color(0xFF16213E),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[700],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4DD0E1)),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${currentAmount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  '₹${targetAmount.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
