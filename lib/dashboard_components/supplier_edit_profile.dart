import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

class SupplierEditProfile extends StatelessWidget {
  const SupplierEditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          title: 'Sup\'s edit profile',
        ),
        leading: AppBarBackButton(),
      ),
    );
  }
}
