import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vet/providers/theme_provider.dart';

void showThemeDialoge(context) {
  showDialog(
    context: context,
    builder: (context) {
      final themeMode = Provider.of<ThemeProvider>(context).themeMode;
      return AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values
              .map((e) => RadioListTile(
                    title: Text(e.toString().split('.').last),
                    value: e,
                    groupValue: themeMode,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .setThemeMode(value!);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      );
    },
  );
}
