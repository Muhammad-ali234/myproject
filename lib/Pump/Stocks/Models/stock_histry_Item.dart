import 'package:cloud_firestore/cloud_firestore.dart';

class StockHistoryItem {
  final String type;
  final double amount;
  final DateTime? timestamp;

  StockHistoryItem({
    required this.type,
    required this.amount,
    this.timestamp,
  });

  factory StockHistoryItem.fromMap(Map<String, dynamic> map) {
    return StockHistoryItem(
      type: map['type'] as String,
      amount: map['amount'] as double,
      timestamp: (map['date'] as Timestamp).toDate(),
    );
  }
}
