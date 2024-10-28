import 'package:flutter/material.dart';
import '../components/header.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/groupedTransaction.dart';
import '../models/transaction.dart';
import '../components/monthSelector.dart';


class Dashboard extends StatelessWidget {
  final Map<String, List<GroupedTransaction>> groupedTransactions;

  Dashboard({required this.groupedTransactions});

  @override
  Widget build(BuildContext context) {
    double totalBalance = calculateTotalBalance(groupedTransactions);
    double startingBalance = 8.2; // This should be calculated or retrieved
    List<Transaction> recentTransactions = getRecentTransactions(groupedTransactions);

    return CustomScrollView(
      slivers: [
        // The rest of your content goes here
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 24),
                MonthSelector(
                  onMonthSelected: (selectedMonth) {
                    // Handle the selected month here
                  },
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.lightBlue[200]!,
                          value: 47,
                          title: 'Savings\n47 L',
                          radius: 80,
                          titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          color: Colors.green[300]!,
                          value: 70,
                          title: 'Investments\n70 K',
                          radius: 80,
                          titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          color: Colors.blue[700]!,
                          value: 60,
                          title: 'Income\n60 K',
                          radius: 80,
                          titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          color: Colors.teal[200]!,
                          value: 22,
                          title: 'Expenditure\n2.2 L',
                          radius: 80,
                          titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Starting Balance: ${startingBalance.toStringAsFixed(1)} L',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Balance: ${totalBalance.toStringAsFixed(1)} L',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBalanceIndicator('4.1 L', Colors.red),
                    _buildBalanceIndicator('3.1 L', Colors.green),
                    _buildBalanceIndicator('20 K', Colors.amber),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceIndicator(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  double calculateTotalBalance(Map<String, List<GroupedTransaction>> groupedTransactions) {
    // Implement your balance calculation logic here
    return 5.3; // This is a placeholder value
  }

  List<Transaction> getRecentTransactions(Map<String, List<GroupedTransaction>> groupedTransactions) {
    // Implement your logic to get recent transactions
    return []; // This is a placeholder
  }
}

// class DashboardTab extends StatelessWidget {
//   final Map<String, List<GroupedTransaction>> groupedTransactions;

//   DashboardTab({required this.groupedTransactions});

//   @override
//   Widget build(BuildContext context) {
//     double totalBalance = calculateTotalBalance(groupedTransactions);
//     List<Transaction> recentTransactions = getRecentTransactions(groupedTransactions);

//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           expandedHeight: 100,
//           floating: false,
//           pinned: true,
//           flexibleSpace: FlexibleSpaceBar(
//             // title: Text('Hi Sid', style: GoogleFonts.raleway()),
//             background: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFF4DD0E1), Color(0xFF1976D2)],
//                 ),
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Total Balance',
//                       style: TextStyle(color: Colors.white70, fontSize: 16),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '₹${totalBalance.toStringAsFixed(2)}',
//                       style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Balance Trend',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//         ),
//         SliverToBoxAdapter(
//           child: Container(
//             height: 200,
//             padding: EdgeInsets.all(16),
//             child: LineChart(
//               LineChartData(
//                 gridData: FlGridData(show: false),
//                 titlesData: FlTitlesData(show: false),
//                 borderData: FlBorderData(show: false),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: getBalanceTrendData(recentTransactions),
//                     isCurved: true,
//                     color: Color(0xFF4DD0E1), // Single color
//                     barWidth: 3,
//                     dotData: FlDotData(show: false),
//                     belowBarData: BarAreaData(show: true, color: Color(0x224DD0E1)), // Single color
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Recent Transactions',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//         ),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               return TransactionTile(transaction: recentTransactions[index]);
//             },
//             childCount: recentTransactions.length > 5 ? 5 : recentTransactions.length,
//           ),
//         ),
//       ],
//     );
//   }

//   double calculateTotalBalance(Map<String, List<GroupedTransaction>> groupedTransactions) {
//     double total = 0;
//     groupedTransactions.values.forEach((groupedTransactionsList) {
//       groupedTransactionsList.forEach((groupedTransaction) {
//         groupedTransaction.transactions.forEach((transaction) {
//           if (transaction.transactionType.toLowerCase() == 'credit') {
//             total += transaction.amount ?? 0;
//           } else {
//             total -= transaction.amount ?? 0;
//           }
//         });
//       });
//     });
//     return total;
//   }

//   List<Transaction> getRecentTransactions(Map<String, List<GroupedTransaction>> groupedTransactions) {
//     List<Transaction> allTransactions = [];
//     groupedTransactions.values.forEach((groupedTransactionsList) {
//       groupedTransactionsList.forEach((groupedTransaction) {
//         allTransactions.addAll(groupedTransaction.transactions);
//       });
//     });
//     allTransactions.sort((a, b) => b.date.compareTo(a.date));
//     return allTransactions;
//   }

//   List<FlSpot> getBalanceTrendData(List<Transaction> transactions) {
//     if (transactions.isEmpty) return [];

//     double balance = 0;
//     List<FlSpot> spots = [];
//     for (int i = transactions.length - 1; i >= 0; i--) {
//       Transaction transaction = transactions[i];
//       if (transaction.transactionType.toLowerCase() == 'credit') {
//         balance += transaction.amount ?? 0;
//       } else {
//         balance -= transaction.amount ?? 0;
//       }
//       spots.add(FlSpot(i.toDouble(), balance));
//     }
//     return spots;
//   }
// }