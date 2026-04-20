import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_checkout.dart';
import 'profile.dart';
import 'home.dart';

// 1. import pages above
class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // This "puts" the controller into memory so it can be accessed anywhere.
    final controller = Get.put(NavigationController());

    return Scaffold(
      // The Obx here listens for changes to 'selectedIndex'
      // It then picks the correct widget from the 'screens' list to fill the empty space.
      body: Obx(() => controller.screens[controller.selectedIndex.value]),

      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,

          // When you tap an icon, we update the .obs value
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,

          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  // .obs makes this variable "Observable" (Reactive)
  final Rx<int> selectedIndex = 0.obs;

  // This is the list of "pages" that will fill the body.
  // Replace the generic Containers with your actual Class names (e.g., HomeScreen())
  final screens = [
    const HomePage(),
    const CartCheckoutWidget(),
    const ProfilePage(),
  ];
}
