import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/authProvider.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'navbar_item.dart';
import 'navbar_logo.dart';

class NavigationBarTabletDesktop extends StatefulWidget {
  const NavigationBarTabletDesktop({Key? key}) : super(key: key);

  @override
  _NavigationBarTabletDesktopState createState() =>
      _NavigationBarTabletDesktopState();
}

class _NavigationBarTabletDesktopState
    extends State<NavigationBarTabletDesktop> {
  bool _isAuthorized = false;
  bool _hasLicense = false;

  @override
  void initState() {
    super.initState();
    _checkAuthorizationAndLicense();
  }

  Future<void> _checkAuthorizationAndLicense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAuthorized = prefs.getBool('isAuthorized') ?? false;
      _hasLicense = prefs.getBool('hasLicense') ?? false;
    });
    print('_isAuthorized: $_isAuthorized');
    print('_hasLicense: $_hasLicense');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = AuthorizationProvider.of(context);
    return Container(
      height: 70,
      color: const Color.fromRGBO(53, 50, 50, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const NavBarLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ValueListenableBuilder<bool>(
                valueListenable: authProvider?.isAuthorizedNotifier ??
                    ValueNotifier<bool>(false),
                builder: (context, isAuthorized, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: authProvider?.hasLicenseNotifier ??
                        ValueNotifier<bool>(false),
                    builder: (context, hasLicense, child) {
                      return Row(
                        children: [
                          if (isAuthorized &&
                              !hasLicense) // Условие для авторизованных пользователей без лицензии
                            ...[
                            NavBarItem('О нас', HomeRoute),
                            const SizedBox(width: 60),
                            NavBarItem('Тарифы', RatesRoute),
                            const SizedBox(width: 60),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: NavBarItem('Выход', LogoutRoute),
                            ),
                          ] else if (isAuthorized &&
                              hasLicense) // Условие для авторизованных пользователей с лицензией
                            ...[
                            NavBarItem('Мой аккаунт', ProfileRoute),
                            const SizedBox(width: 60),
                            NavBarItem(
                                'Подключение устройств', ConnectDevicesRoute),
                            const SizedBox(width: 60),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: NavBarItem('Выход', LogoutRoute),
                            ),
                          ] else // Условие для неавторизованных пользователей
                            ...[
                            NavBarItem('О нас', HomeRoute),
                            const SizedBox(width: 60),
                            NavBarItem('Тарифы', RatesRoute),
                            const SizedBox(width: 60),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: NavBarItem('Авторизация', LoginRoute),
                            ),
                          ],
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
