import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pairsonic/helper/ui/gui_constants.dart';

class RoleSelectionCardWidget extends StatelessWidget {
  final String assetName;
  final String title;
  final String description;
  final Function() action;

  const RoleSelectionCardWidget(
      {super.key, required this.assetName,
      required this.title,
      required this.description,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: action,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture(
                    SvgAssetLoader(assetName,
                        colorMapper: SvgColorReplacer({
                          Colors.black: Theme.of(context).colorScheme.onSurface,
                        })),
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(description,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const Spacer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
