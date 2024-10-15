import 'package:flutter/material.dart';

/// Row with two buttons, usually located at the bottom of the screen.
/// The primary button is the one on the right, filled with the accent color,
/// the secondary button is on the left, filled with the secondary color.
class ButtonRow extends StatelessWidget {
  final String primaryText;
  final IconData primaryIcon;
  final Function(BuildContext)? primaryAction;

  final String secondaryText;
  final IconData secondaryIcon;
  final Function(BuildContext)? secondaryAction;

  const ButtonRow({
    super.key,
    required this.primaryText,
    required this.primaryIcon,
    this.primaryAction,
    required this.secondaryText,
    required this.secondaryIcon,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(secondaryIcon),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(secondaryText),
            ),
            iconAlignment: IconAlignment.start,
            onPressed: secondaryAction != null
                ? () => secondaryAction?.call(context)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            icon: Icon(primaryIcon),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(primaryText),
            ),
            iconAlignment: IconAlignment.end,
            onPressed: primaryAction != null
                ? () => primaryAction?.call(context)
                : null,
          ),
        ),
      ],
    );
  }
}
