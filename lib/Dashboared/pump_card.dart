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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 4.0,
          child: SizedBox(
            height: 110,
            width: 180,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    pumpName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InfoItem(label: 'Earnings', value: '\$5000'),
                      SizedBox(
                        width: 15,
                      ),
                      InfoItem(label: 'Profit', value: '\$2000'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
