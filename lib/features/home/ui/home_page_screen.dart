import 'package:flutter/material.dart';
import 'package:pairsonic/router/app_routes.dart';
import 'package:pairsonic/generated/l10n.dart';

import 'menu_card_widget.dart';

/// The Home Screen of the app with buttons as grid tiles.
/// Each Button is from [MenuCard] Widget.
/// {@category Screens}
class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  initState() {
    FocusManager.instance.primaryFocus
        ?.unfocus(); //Remove Keyboard in this screen
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    GridView menuCardGrid = GridView.count(
      crossAxisCount: isLandscape ? 3 : 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(6),
      childAspectRatio: isLandscape ? 1.5 : 1.3,
      children: [
        MenuCard(
            icon: Icons.person_rounded,
            title: S.of(context).profile,
            route: AppRoutes.profile),
        MenuCard(
            icon: Icons.contact_page,
            title: S.of(context).contacts,
            route: AppRoutes.contacts),
        MenuCard(
            icon: Icons.link,
            title: S.of(context).pair,
            route: AppRoutes.pairing),
      ],
    );

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              // DrawerHeader(child: Text('Main Menu')),
              _buildDrawerMenuOption(
                Icons.settings,
                S.of(context).settings,
                AppRoutes.settings,
                context,
              ),
            ],
          ),
        ),
      ),
      body: menuCardGrid,
      appBar: AppBar(
        // leading: IconButton(onPressed: ()=> scaffoldKey.currentState!.openDrawer(), icon: Icon(Icons.monetization_on)),
        title: Text(S.of(context).appName),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
              icon: const Icon(Icons.settings))
        ],
      ),
    );
  }

  ListTile _buildDrawerMenuOption(
    IconData icon,
    String title,
    String route,
    BuildContext context,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
