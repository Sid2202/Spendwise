import 'transaction.dart';

class GroupedTransaction {
  final String bankName;
  final String? accountNumber;
  final List<Transaction> transactions;

  GroupedTransaction({
    required this.bankName,
    this.accountNumber,
    required this.transactions,
  });
}