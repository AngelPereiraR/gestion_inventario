import 'package:flutter/material.dart';

import '../views/views.dart';
import '../widgets/custom_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final viewRoutes = const <Widget>[HomeView(), TestView()];
  late PageController _pageController;
  int _currentPage = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            // Swipe from left to right (previous screen)
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
              setState(() {
                _currentPage--;
              });
            }
          } else {
            // Swipe from right to left (next screen)
            if (details.velocity.pixelsPerSecond.dx < 0) {
              if (_currentPage < 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
                setState(() {
                  _currentPage++;
                });
              }
            }
          }
        },
        child: PageView.builder(
            itemCount: viewRoutes.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              _currentPage = index;
              return viewRoutes[index];
            }),
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: _currentPage),
    );
  }
}
