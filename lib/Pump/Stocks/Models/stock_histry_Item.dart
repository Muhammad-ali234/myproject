import 'package:cloud_firestore/cloud_firestore.dart';

class StockHistoryItem {
  final String type;
  final double litres;
  final DateTime? timestamp;

  StockHistoryItem({
    required this.type,
    required this.litres,
    this.timestamp,
  });

  factory StockHistoryItem.fromMap(Map<String, dynamic> map) {
    return StockHistoryItem(
      type: map['type'] as String,
      litres: map['litres'] as double,
      timestamp: (map['date'] as Timestamp).toDate(),
    );
  }
}
