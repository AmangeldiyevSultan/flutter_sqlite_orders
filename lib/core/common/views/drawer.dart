import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sqlite/core/common/widgets/app_bar.dart';
import 'package:flutter_sqlite/core/common/widgets/drawer.dart';
import 'package:flutter_sqlite/src/orders/widget/orders_screen.dart';
import 'package:flutter_sqlite/src/products/widget/products_screen.dart';

class AppDrawerPages extends StatefulWidget {
  const AppDrawerPages({super.key});

  @override
  State<AppDrawerPages> createState() => _AppDrawerPagesState();
}

class _AppDrawerPagesState extends State<AppDrawerPages> {
  int _selectedIndex = 0;

  final _drawerPages = <Widget>[
    const ProductScreen(),
    const OrderScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: DrawerAppBar(
          selectedPage: _selectedIndex,
        ),
      ),
      drawer: AppDrawer(
        onPressed: _onItemTapped,
      ),
      body: _drawerPages[_selectedIndex],
    );
  }
}
