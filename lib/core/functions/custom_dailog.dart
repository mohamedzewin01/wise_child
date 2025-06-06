

import 'package:flutter/material.dart';
import 'package:wise_child/core/resources/color_manager.dart';

class CustomDialog {
static  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // يمنع الإغلاق بالنقر خارج النافذة
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Center(
            child: const CircularProgressIndicator(
              color: ColorManager.primaryColor,
            ),
          ),
        );
      },
    );
  }

}