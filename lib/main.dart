import 'package:babyshophub/data/repository/auth_repository.dart';
import 'package:babyshophub/page/cart_checkout.dart';
import 'package:babyshophub/page/home.dart';
import 'package:babyshophub/page/login.dart';
import 'package:babyshophub/page/navbar.dart';
import 'package:babyshophub/page/profile.dart';
import 'package:babyshophub/page/register.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _router = GoRouter(
  initialLocation: '/register',
  redirect: (context, state) {
    final isLoggedIn = PreferencesRepository().isLoggedIn();
    final isOnLoginOrRegisterPage =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (isLoggedIn && isOnLoginOrRegisterPage) return '/homeNav';
    if (!isLoggedIn && !isOnLoginOrRegisterPage) return '/login';
    return null;
  },
  routes: [
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/homeNav',
      builder: (context, state) => const NavigationMenu(),
    ),
    GoRoute(
      path: CartCheckoutWidget.routePath,
      builder: (context, state) => const CartCheckoutWidget(),
    ),
    GoRoute(
      path: ProfilePage.routePath,
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("babyshophub_preferences");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routerConfig: _router,
    );
  }
}
