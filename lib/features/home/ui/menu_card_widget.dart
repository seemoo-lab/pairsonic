import 'package:flutter/material.dart';

/// Widget to show a button for the main screen
///
/// {@category Widgets}
class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const MenuCard({super.key, required this.icon, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Spacer(),
              Icon(
                icon,
                size: 64,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
