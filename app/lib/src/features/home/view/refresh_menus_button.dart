import 'dart:collection';

import 'package:flutter/material.dart';
import '../../../shared/classes/classes.dart';
import '../../../shared/providers/menus.dart';

class RefreshMenusButton extends StatelessWidget {
  const RefreshMenusButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () async {
        print('Refresh icon pressed');
        SplayTreeMap<String, Menu> menus = await MenuProvider.shared.refresh();
        MenusChange(menus: menus).dispatch(context);
      },
    );
  }
}
