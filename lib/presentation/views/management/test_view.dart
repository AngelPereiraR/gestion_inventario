import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Text View'),
      ),
      body: const Center(
        child: Text('Text'),
      ),
    );
  }
}
