abstract class PageCommand {}

/// Command to inform the UI to show an ERROR message
class ShowErrorMessage extends PageCommand {
  final String message;

  ShowErrorMessage(this.message);
}

/// Command to inform the UI to show a REGULAR (not error) message
class ShowMessage extends PageCommand {
  final String message;

  ShowMessage(this.message);
}

/// Command to inform the UI to Navigate to a specific route
class NavigateToRoute extends PageCommand {
  final String route;

  NavigateToRoute(this.route);
}

/// Command to inform the UI to Navigate to a specific route and pass arguments
class NavigateToRouteWithArguments<T> extends PageCommand {
  final String route;
  final T arguments;

  NavigateToRouteWithArguments({
    required this.route,
    required this.arguments,
  });
}
