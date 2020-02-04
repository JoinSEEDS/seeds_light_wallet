import 'package:flutter/material.dart';
import 'package:seeds/providers/services/navigation_service.dart';
import 'package:seeds/widgets/main_button.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MainButton(
        title: "Logout",
        onPressed: () {
          NavigationService.of(context).navigateTo(Routes.logout);
        },
      ),
    );
  }
}
