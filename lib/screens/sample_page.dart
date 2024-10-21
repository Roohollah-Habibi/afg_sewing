import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Coming Soon',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.indigo),
            ),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushReplacementNamed(RouteManager.root);
            }, child: const Text('Return Home'))
          ],
        ),
      ),
    );
  }
}
