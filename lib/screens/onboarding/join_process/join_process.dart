import './export.dart';

class JoinProcess extends StatefulWidget {
  @override
  _JoinProcessState createState() => _JoinProcessState();
}

class _JoinProcessState extends State<JoinProcess> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(
        settings: Provider.of<SettingsNotifier>(context, listen: false),
        links: Provider.of<LinksService>(context, listen: false),
        http: Provider.of<HttpService>(context, listen: false),
        eos: Provider.of<EosService>(context, listen: false),
      ),
      child: JoinProcessOverlay(),
    );
  }
}
