import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onItemTapped;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  void onItemSelected(BuildContext context, int index) {
    onItemTapped(index);
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (value) => onItemSelected(context, value),
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max_outlined),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.preview_outlined),
          label: 'Prueba',
        ),
      ],
    );
  }
}
