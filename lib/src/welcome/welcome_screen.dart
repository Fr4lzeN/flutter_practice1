import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:practice1/src/navigation/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добро пожаловать')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Это трекер задач!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Нажмите кнопку ниже, чтобы начать.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.pushReplacement(AppRouter.tasksRoute);
              },
              child: const Text('Начать'),
            ),
          ],
        ),
      ),
    );
  }
}
