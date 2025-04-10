import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 3,
            color: Colors.red,
          ),
          fixedSize: Size(1, 75),
        ),
        onPressed: () {
          //TODO 
        },
        child: Text(
          'Emergency Call',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
        ));
  }
}
