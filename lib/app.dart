
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


class Nexus extends StatelessWidget {
  const Nexus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NexusHome(),
    );
  }
}
