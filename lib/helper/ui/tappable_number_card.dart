import 'package:flutter/material.dart';

class TappableNumberCard extends StatelessWidget {
  final int _num;
  final Function()? _onTap;

  TappableNumberCard(this._num, {Function()? onTap}) : _onTap = onTap;

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
            Text("$_num", style: Theme.of(context).textTheme.headlineLarge),
          ],
        ),
      ),
    );
  }
}
