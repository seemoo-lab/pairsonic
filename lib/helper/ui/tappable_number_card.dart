import 'package:flutter/material.dart';

class TappableNumberCard extends StatelessWidget {
  final String _text;
  final Function()? _onTap;

  const TappableNumberCard(int num, {super.key, Function()? onTap})
      : _text = "$num",
        _onTap = onTap;

  const TappableNumberCard.emoji(String emoji, {super.key, Function()? onTap})
      : _text = emoji,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: _onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text, style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
      ),
    );
  }
}
