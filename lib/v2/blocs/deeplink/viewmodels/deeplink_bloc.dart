import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/v2/blocs/deeplink/mappers/deep_link_state_mapper.dart';
import 'package:seeds/v2/blocs/deeplink/usecase/get_initial_deep_link_use_case.dart';
import 'package:seeds/v2/blocs/deeplink/usecase/get_signing_request_use_case.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_event.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_state.dart';
import 'package:uni_links/uni_links.dart';

/// --- BLOC
class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
  StreamSubscription? _linkStreamSubscription;

  DeeplinkBloc() : super(DeeplinkState.initial()) {
    initDynamicLinks();
    initSigningRequests();
  }

  @override
  Future<void> close() {
    _linkStreamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<DeeplinkState> mapEventToState(DeeplinkEvent event) async* {
    if (event is HandleIncomingFirebaseDeepLink) {
      final result = await GetInitialDeepLinkUseCase().run(event.newLink);
      yield DeepLinkStateMapper().mapResultToState(state, result);
    } else if (event is OnGuardianRecoveryRequestSeen) {
      yield state.copyWith();
    } else if (event is ClearDeepLink) {
      yield DeeplinkState.initial();
    } else if (event is HandleIncomingSigningRequest) {
      final result = await GetSigningRequestUseCase().run(event.link);
      yield DeepLinkStateMapper().mapSigningRequestToState(state, result);
    }
  }

  Future<void> initDynamicLinks() async {
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

  Future<void> initSigningRequests() async {
    try {
      final initialLink = await getInitialLink();

      if (initialLink != null) {
        add(HandleIncomingSigningRequest(initialLink));
      }
    } catch (err) {
      print("initial link error: $err");
    }

    _linkStreamSubscription = linkStream.listen((String? uri) {
      if (uri != null) {
        add(HandleIncomingSigningRequest(uri));
      }
    }, onError: (err) {
      print("ESR Error: ${err.toString()}");
    });
  }
}
