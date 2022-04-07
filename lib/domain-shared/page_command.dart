import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';

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

class NavigateToSendConfirmation extends NavigateToRouteWithArguments {
  NavigateToSendConfirmation(SendConfirmationArguments args) : super(route: Routes.sendConfirmation, arguments: args);
}
