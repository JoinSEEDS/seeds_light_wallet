class AppUtils {
  /// The App will set this function for plugins switch between each other
  Future<void> Function(String network, {PageRouteParams? pageRoute})?
      switchNetwork;
}

class PageRouteParams {
  PageRouteParams(this.path, {this.args});

  final String path;
  final Map? args;
}
