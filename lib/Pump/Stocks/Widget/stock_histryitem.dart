import 'package:flutter/material.dart';
import 'package:myproject/Pump/Stocks/Models/stock_histry_Item.dart';

class StockHistoryItemWidget extends StatelessWidget {
  final StockHistoryItem historyItem;

  const StockHistoryItemWidget({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text('${historyItem.type}: ${historyItem.litres}'),
        subtitle: Text('Updated on ${historyItem.timestamp.toString()}'),
      ),
    );
  }
}
