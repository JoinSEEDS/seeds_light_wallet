import 'package:bloc/bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/v2/blocs/deeplink/mappers/deep_link_state_mapper.dart';
import 'package:seeds/v2/blocs/deeplink/usecase/get_initial_deep_link_use_case.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_event.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_state.dart';

/// --- BLOC
class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
  DeeplinkBloc() : super(DeeplinkState.initial()) {
    initDynamicLinks();
  }

  @override
  Stream<DeeplinkState> mapEventToState(DeeplinkEvent event) async* {
    if (event is HandleIncomingFirebaseDeepLink) {
      var result = await GetInitialDeepLinkUseCase().run(event.newLink);
      yield DeepLinkStateMapper().mapResultToState(state, result);
    } else if (event is OnGuardianRecoveryRequestSeen) {
      yield state.copyWith(showGuardianApproveOrDenyScreen: null);
    }
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onError: (error) async {},
        onSuccess: (dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;

          if (deepLink != null) {
            add(HandleIncomingFirebaseDeepLink(deepLink));
          }
        });

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      add(HandleIncomingFirebaseDeepLink(deepLink));
    }
  }
}
