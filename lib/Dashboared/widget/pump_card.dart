import 'package:flutter/material.dart';

class PumpCard extends StatelessWidget {
  final String pumpName;
  final VoidCallback onTap;

  const PumpCard({
    super.key,
    required this.pumpName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_gas_station,
                size: 40,
                color: Colors.teal,
              ),
              const SizedBox(height: 10),
              Text(
                pumpName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}