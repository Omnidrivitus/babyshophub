import 'package:babyshophub/data/repository/auth_repository.dart';
import 'package:babyshophub/page/cart_checkout.dart';
import 'package:babyshophub/page/login.dart';
import 'package:babyshophub/page/navbar.dart';
import 'package:babyshophub/page/order_history.dart';
import 'package:babyshophub/page/profile.dart';
import 'package:babyshophub/page/register.dart';
import 'package:babyshophub/page/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:babyshophub/page/payment_addrress.dart';

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
    GoRoute(
      path: OrderHistoryPage.routePath,
      builder: (context, state) => const OrderHistoryPage(),
    ),
    GoRoute(
      path: PaymentAddressPage.routePath,
      builder: (context, state) => const PaymentAddressPage(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'];
        return ResetPasswordPage(token: token!);
      },
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
