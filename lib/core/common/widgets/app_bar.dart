import 'package:flutter/material.dart';

class DrawerAppBar extends StatelessWidget {
  const DrawerAppBar({
    required this.selectedPage,
    super.key,
  });

  final int selectedPage;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        selectedPage == 0 ? 'Products' : 'Orders',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
