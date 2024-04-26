class Transaction {
  final String type;
  final String amount;
  final DateTime date;

  Transaction({
    required this.type,
    required this.amount,
    required this.date,
  });

  // Define a static list to store transactions
  static List<Transaction> allTransactions = [];

  // Add a static method to add a transaction to the list
  static void addTransaction(Transaction transaction) {
    allTransactions.add(transaction);
  }
}
