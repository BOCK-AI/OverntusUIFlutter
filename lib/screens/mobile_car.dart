import 'package:flutter/material.dart';

class MobileCar extends StatelessWidget {
  const MobileCar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Car")),
      body: const Center(child: Text("Car Page UI")),
    );
  }
}