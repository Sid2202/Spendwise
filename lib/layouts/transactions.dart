
import 'package:flutter/material.dart';
import 'package:money_tracker/components/monthSelector.dart';
import 'package:money_tracker/services/sms_service.dart';
import '../models/transaction.dart';
import '../models/groupedTransaction.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';



class Transactions extends StatefulWidget {
  final Map<String, List<GroupedTransaction>> groupedTransactions;

  Transactions({required this.groupedTransactions});

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late Map<String, List<GroupedTransaction>> groupedTransactions;
  late double totalIncome;
  late double totalExpenditure;
  late double savings;
  int touchedIndex = -1;

  final List<Color> chartColors = [
    Color(0xff0293ee),
    Color(0xfff8b250),
  ];

  @override
  void initState() {
    super.initState();
    groupedTransactions = widget.groupedTransactions;
    calculateFinancialSummary();
  }

  void calculateFinancialSummary() {
    totalIncome = 0;
    totalExpenditure = 0;
    
    getAllTransactions(groupedTransactions).forEach((transaction) {
      if (transaction.amount == null) return;
      if (transaction.transactionType.toLowerCase() == 'credit') {
        totalIncome += transaction.amount ?? 0;
        print("@@@@@ credit transaction.amount: ${transaction.amount}");
      } else if( transaction.transactionType.toLowerCase() == 'debit') {
        totalExpenditure += transaction.amount ?? 0;
        print("@@@@@ debit transaction.amount: ${transaction.amount}");
      }
    });
    
    savings = totalIncome - totalExpenditure;
    if (savings < 0) savings = 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> allTransactions = getAllTransactions(groupedTransactions);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Financial Summary',
                  style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                const SizedBox(height: 24),
                MonthSelector(
                  onMonthSelected: (selectedMonth) async {
                    final newGroupedTransactions = await SMSService.retrieveTransactions(selectedMonth);
                    setState(() {
                      groupedTransactions = newGroupedTransactions;
                      allTransactions = getAllTransactions(groupedTransactions);
                      calculateFinancialSummary();
                    });
                  },
                ),
                const SizedBox(height: 24),
                Container(
                  height: 200,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 0,
                          centerSpaceRadius: 60,
                          sections: showingSections(),
                        ),
                      ),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Total Income',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${totalIncome.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FinancialSummaryDetails(
                  income: totalIncome,
                  expenditure: totalExpenditure,
                  savings: savings,
                  colors: chartColors,
                ),
                const SizedBox(height: 24),const Text(
                  'Transactions',
                  style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),
          ),
        ),
        allTransactions.isEmpty
          ? SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No transactions recorded',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return TransactionTile(transaction: allTransactions[index]);
                },
                childCount: allTransactions.length,
              ),
            ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: chartColors[0],
            value: totalExpenditure,
            title: '${(totalExpenditure / totalIncome * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: chartColors[1],
            value: savings,
            title: '${(savings / totalIncome * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }

  List<Transaction> getAllTransactions(Map<String, List<GroupedTransaction>> groupedTransactions) {
    List<Transaction> allTransactions = [];
    groupedTransactions.values.forEach((groupedTransactionsList) {
      groupedTransactionsList.forEach((groupedTransaction) {
        allTransactions.addAll(groupedTransaction.transactions);
      });
    });
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    return allTransactions;
  }
}

class FinancialSummaryDetails extends StatelessWidget {
  final double income;
  final double expenditure;
  final double savings;
  final List<Color> colors;

  const FinancialSummaryDetails({
    Key? key,
    required this.income,
    required this.expenditure,
    required this.savings,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // _buildSummaryRow('Income', income, Color.fromARGB(255, 238, 2, 2)),
        _buildSummaryRow('Expenditure', expenditure, colors[0]),
        _buildSummaryRow('Savings', savings, colors[1]),
      ],
    );
  }

  Widget _buildSummaryRow(String title, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}


class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    if (transaction.transactionType.toLowerCase() == 'debit') {
      icon = Icons.arrow_downward;
      color = Colors.red;
    } else {
      icon = Icons.arrow_upward;
      color = Colors.green;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        '${transaction.amount != null ? '₹${transaction.amount!.toStringAsFixed(2)}' : 'Unknown amount'}',
        style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 2, 2, 2)),
      ),
      subtitle: Text(
        DateFormat('MMM d, y').format(transaction.date.toLocal()),
        style: TextStyle(color: const Color.fromARGB(255, 52, 52, 52)),
      ),
      trailing: Icon(Icons.chevron_right, color: const Color.fromARGB(255, 3, 3, 3)),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => TransactionDetails(transaction: transaction),
        );
      },
    );
  }
}

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetails({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 242, 244, 248),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Transaction Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 45, 45, 45)),
            ),
            const SizedBox(height: 20),
            DetailRow(title: 'Type', value: transaction.transactionType.toUpperCase()),
            DetailRow(
              title: 'Amount',
              value: transaction.amount != null
                  ? '₹${transaction.amount!.toStringAsFixed(2)}'
                  : 'Unknown amount',
            ),
            DetailRow(
              title: 'Bankname', 
              value: transaction.bankName,
            ),
            DetailRow(
              title: 'Account Number',
              value: transaction.accountNumber ?? 'Unknown',
            ),
            DetailRow(
              title: 'Date',
              value: DateFormat('MMMM d, y HH:mm').format(transaction.date.toLocal()),
            ),
            DetailRow(title: 'Message', value: transaction.originalMessage),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: const Color.fromARGB(255, 9, 9, 9))),
          ),
        ],
      ),
    );
  }
}