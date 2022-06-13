import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorPaletteRepository {
  static final Map<ImageProvider, Color?> _cache = {};

  Future<Color?> getImagePaletteCached(ImageProvider imageProvider) async {
    if (_cache[imageProvider] != null) {
      return _cache[imageProvider];
    }
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    final Color? color = paletteGenerator.dominantColor?.color;

    _cache[imageProvider] = color;
    return color;
  }
}
