import 'package:provider/provider.dart';
import 'package:seeds/v2/navigation/navigation_service.dart';

final providers = [
  Provider(create: (_) => NavigationService()),
];
