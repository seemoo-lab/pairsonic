import 'package:flutter/material.dart';

class HintTextCard extends StatelessWidget {
  final String _text;
  final IconData _icon;
  final TextStyle? _textStyle;

  const HintTextCard(this._text, {super.key, icon = Icons.lightbulb, TextStyle? textStyle})
      : _icon = icon,
        _textStyle = textStyle;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0.0,
        color: Theme.of(context).colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8.0),
                child: Icon(
                  _icon,
                  size: Theme.of(context).iconTheme.size,
                ),
              ),
              Flexible(
                child: Text(
                  _text,
                  style: _textStyle ?? TextStyle(
                      fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
                ),
              )
            ],
          ),
        ));
  }
}
