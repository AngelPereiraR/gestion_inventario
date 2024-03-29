import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';
import '../widgets.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;

    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);

        return NavigationDrawer(
          elevation: 1,
          selectedIndex: navDrawerIndex,
          onDestinationSelected: (value) {
            setState(() {
              navDrawerIndex = value;
            });

            widget.scaffoldKey.currentState?.closeDrawer();
          },
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, hasNotch ? 20 : 40, 16, 0),
              child: Text('Saludos', style: textStyles.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
              child: Text(authState.user != null ? authState.user!.name : '',
                  style: textStyles.titleSmall),
            ),
            const NavigationDrawerDestination(
              icon: Icon(Icons.inventory_outlined),
              label: Text('Gestión de inventario'),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
              child: Divider(),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
              child: Text('Otras opciones'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: authState.user != null
                  ? CustomFilledButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                      },
                      text: 'Cerrar sesión',
                    )
                  : CustomFilledButton(
                      onPressed: () {
                        context.push('/auth/0');
                      },
                      text: 'Iniciar sesión',
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: authState.user == null
                  ? CustomFilledButton(
                      onPressed: () {
                        context.push('/auth/1');
                      },
                      text: 'Registrarse',
                    )
                  : const Center(),
            ),
          ],
        );
      },
    );
  }
}
