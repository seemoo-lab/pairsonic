import 'package:flutter/material.dart';
import 'package:pairsonic/features/profile/identity_service.dart';
import 'package:pairsonic/service_locator.dart';

class BottomInfoWidget extends StatefulWidget {
  const BottomInfoWidget({super.key});

  @override
  State<BottomInfoWidget> createState() => _BottomInfoWidget();
}

class _BottomInfoWidget extends State<BottomInfoWidget> {
  final _identityService = getIt<IdentityService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Text(_identityService.self.id,
                  style: const TextStyle(color: Colors.white))
            ]),
            const Text("Build Info", style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}
