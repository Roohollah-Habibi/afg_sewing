import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('In progress...😉',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            TextButton.icon(onPressed: () => Navigator.of(context)
                .pushReplacementNamed(RouteManager.root),label: const Text('Return Home',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),), icon: const Icon(Icons.recycling,size: 35,)),
          ],
        ),
      ),
    );
  }
}
