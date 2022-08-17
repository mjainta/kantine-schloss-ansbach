import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:schlosskantine/src/features/home/home.dart';
import 'package:schlosskantine/src/shared/providers/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/classes/classes.dart';
import '../../../shared/providers/menus.dart';

final Uri _url =
    Uri.parse('https://github.com/mjainta/kantine-schloss-ansbach');

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final theme = ThemeProvider.of(context).theme(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Info'),
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back),
            onTap: () {
              return GoRouter.of(context).go('/');
            },
          ),
          actions: const [BrightnessToggle()],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              const Text(
                'Ich freue mich, dass du diese App verwendest! Vielen Dank 😊',
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Made with ❤️ by mjainta '),
                  SizedBox(
                    height: 32,
                    child: GestureDetector(
                      onTap: _launchUrl,
                      child: Image.asset(
                        'assets/github_logo.jpg',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
