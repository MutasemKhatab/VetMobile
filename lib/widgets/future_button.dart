import 'package:flutter/material.dart';

class FutureButton extends StatefulWidget {
  const FutureButton({super.key, required this.onTap, required this.title});
  final Future<void> Function() onTap;
  final String title;
  @override
  State<FutureButton> createState() => _FutureButtonState();
}

class _FutureButtonState extends State<FutureButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        await widget.onTap();
        setState(() {
          _isLoading = false;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLoading
          ? CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : Text(widget.title),
    );
  }
}
