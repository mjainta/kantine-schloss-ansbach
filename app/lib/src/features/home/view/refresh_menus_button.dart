import 'dart:collection';

import 'package:flutter/material.dart';
import '../../../shared/classes/classes.dart';
import '../../../shared/providers/menus.dart';

class RefreshMenusButton extends StatelessWidget {
  const RefreshMenusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () async {
        SplayTreeMap<String, Menu> menus = await MenuProvider().refresh();
        MenusChange(menus: menus).dispatch(context);
      },
    );
  }
}
