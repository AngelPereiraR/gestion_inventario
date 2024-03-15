import 'package:flutter/material.dart';

import '../../views/views.dart';
import '../../widgets/widgets.dart';

class AuthScreen extends StatefulWidget {
  static const name = 'auth-screen';
  final int pageIndex;

  const AuthScreen({super.key, required this.pageIndex});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final viewRoutes = <Widget>[
    const LoginView(),
    const RegisterView(),
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              // Swipe from left to right (previous screen)
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            } else if (details.velocity.pixelsPerSecond.dx < 0) {
              // Swipe from right to left (next screen)
              if (_currentPage < viewRoutes.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            }
          },
          child: PageView(
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: viewRoutes,
          ),
        ),
      ),
      bottomNavigationBar: CustomAuthBottomNavigation(
        currentIndex: _currentPage,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
