import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CtmToaster {
  const CtmToaster._();

  static void showError(
    BuildContext context, {
    required String msg,
  }) {
    FToast().init(context).showToast(
          child: _toaster(msg, context, const Color.fromARGB(255, 232, 67, 67)),
          gravity: ToastGravity.BOTTOM,
        );
  }

  static void show(
    BuildContext context, {
    required String msg,
  }) {
    FToast().init(context).showToast(
          child:
              _toaster(msg, context, const Color.fromARGB(255, 58, 156, 109)),
          gravity: ToastGravity.BOTTOM,
        );
  }

  static Container _toaster(String msg, BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
