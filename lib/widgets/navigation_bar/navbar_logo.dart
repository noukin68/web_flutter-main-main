import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 150,
      child: Image.asset('assets/logoController.png'),
    );
  }
}
