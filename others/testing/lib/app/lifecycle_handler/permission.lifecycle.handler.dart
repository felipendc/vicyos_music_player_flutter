import 'package:flutter/material.dart';

class PermissionLifecycleHandler with WidgetsBindingObserver {
  final VoidCallback onResume;

  PermissionLifecycleHandler({required this.onResume}) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
