import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('No route'),),
      body: Center(
        child: Text('Seems you stumbled upon wrong route'),
      ),
    );
  }
}
