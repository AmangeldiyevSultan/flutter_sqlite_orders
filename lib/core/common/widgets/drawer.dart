import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    required this.onPressed,
    super.key,
  });

  final void Function(int selectedPage)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 100.h,
            child: const DrawerHeader(
              margin: EdgeInsets.zero,
              child: Text('Sultan Amangeldiyev\nEmployee'),
            ),
          ),
          ListTile(
            title: const Text('Products'),
            onTap: () => onPressed!(0),
          ),
          ListTile(
            title: const Text('Orders'),
            onTap: () => onPressed!(1),
          ),
        ],
      ),
    );
  }
}
