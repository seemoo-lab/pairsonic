import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/user_model.dart';

class IconSelectionScreen extends StatelessWidget {
  const IconSelectionScreen({required this.onSelected, super.key});
  final Function(int index) onSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a profile icon"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GridView.count(
          crossAxisCount: 4,
          children: List<Widget>.generate(
            // Don't show last icon because it is dummy for self-added users
            User.iconIdPathMapping.values.length - 1,
            (index) => IconButton(
              onPressed: (() {
                onSelected(index);
                Navigator.pop(context);
              }),
              iconSize: MediaQuery.of(context).size.width,
              icon: CircleAvatar(
                maxRadius: MediaQuery.of(context).size.width,
                foregroundImage:
                    ExactAssetImage(User.iconIdPathMapping[index]!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
