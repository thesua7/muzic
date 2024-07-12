
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muzic/config/theme/theme_provider.dart';
import 'package:muzic/features/home/presentation/widgets/appbar.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Settings"),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Dark Mode",style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            CupertinoSwitch(
              value:
                  Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              onChanged: (value) =>
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(),
            )
          ],
        ),
      ),
    );
  }
}
