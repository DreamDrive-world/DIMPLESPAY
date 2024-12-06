class User {
  final String name;
  final String email;
  final double balance;
  final List<Transaction> transactions;

  User({
    required this.name,
    required this.email,
    required this.balance,
    required this.transactions,
  });
}

class Transaction {
  final String date;
  final double amount;

  Transaction({
    required this.date,
    required this.amount,
  });
}
