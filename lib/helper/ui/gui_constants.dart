import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuiConstants {
  static const Color scaffoldBackgroundColorLight = Color.fromRGBO(255, 249, 238, 1.0);
  static const Color scaffoldBackgroundColorDark = Color.fromRGBO(0, 0, 0, 1.0);

  static Widget svgAssetExchange(BuildContext context, {required double height}) {
    return SvgPicture(
        SvgAssetLoader(
          "assets/grouppairing/exchange.svg",
          colorMapper: SvgColorReplacer({
            Colors.black: Theme.of(context).colorScheme.onSurface,
            const Color.fromRGBO(252, 252, 252, 1.0): Theme.of(context).colorScheme.surface,
          }),
        ),
        height: height,
    );
  }

  static final ButtonStyle destructiveButtonStyle = ButtonStyle(
    foregroundColor: WidgetStateProperty.all(Colors.red),
  );
}


class SvgColorReplacer implements ColorMapper {
  const SvgColorReplacer(this.mapping);

  final Map<Color, Color> mapping;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    if (mapping.containsKey(color)) {
      return mapping[color]!;
    }

    return color;
  }
}
