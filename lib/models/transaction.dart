class Transaction {
  final String bankName;
  final String transactionType; // 'debit' or 'credit'
  final String? accountNumber;
  final double? amount;
  final double? balance;
  final DateTime date;
  final String originalMessage;
  final Map<String, dynamic> additionalDetails;

  Transaction({
    required this.bankName,
    required this.transactionType,
    this.accountNumber,
    this.amount,
    this.balance,
    required this.date,
    required this.originalMessage,
    this.additionalDetails = const {},
  });
}