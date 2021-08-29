import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorPaletteRepository {
  static final Map<String, Color?> _cache = {};
// Calculate dominant color from ImageProvider
  Future<Color?> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor?.color;
  }

  Future<Color?> getImagePaletteCached(String assetName) async {
    if (_cache[assetName] != null) {
      return _cache[assetName];
    }
    //final stopwatch = Stopwatch()..start();
    final imageProvider = AssetImage(assetName);
    // print('PaletteGenerator AssetImage executed in ${stopwatch.elapsed}');
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
    final Color? color = paletteGenerator.dominantColor?.color;
    //print('PaletteGenerator executed in ${stopwatch.elapsed}');// about 0.1 seconds - not great

    _cache[assetName] = color;
    return color;
  }
}
