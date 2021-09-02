import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorPaletteRepository {
  static final Map<String, Color?> _cache = {};

  Future<Color?> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
  }

  Future<Color?> getImagePaletteCached(String assetName) async {
    if (_cache[assetName] != null) {
      return _cache[assetName];
    }
    final imageProvider = AssetImage(assetName);
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    final Color? color = paletteGenerator.dominantColor?.color;

    _cache[assetName] = color;
    return color;
  }
}
