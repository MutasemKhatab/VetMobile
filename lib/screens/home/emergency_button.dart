import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vet/utils/app_localizations.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({
    super.key,
  });

  Future<void> _makeEmergencyCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+96227201000');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Could not launch $phoneUri');
    }
  }

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
        onPressed: _makeEmergencyCall,
        child: Text(
          context.tr('call_emergency'),
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
        ));
  }
}
