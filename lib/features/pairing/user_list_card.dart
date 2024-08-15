import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/user_model.dart';

class UserListCard extends StatelessWidget {
  final User u;
  final bool isSelected;
  final Function() onTap;

  const UserListCard({super.key, required this.u, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (value) => onTap(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        secondary: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: u.verified ? Colors.green : Colors.red,
                  width: 3.0,
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: ExactAssetImage(u.iconPath),
              ),
            ),
          ],
        ),
        title: Text(u.name),
        subtitle: Text(u.bio, maxLines: 2),
        selected: isSelected,
      ),
    );
  }
}
