import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/blocs/deeplink/mappers/deep_link_state_mapper.dart';
import 'package:seeds/blocs/deeplink/mappers/eosio_signing_request_state_mapper.dart';
import 'package:seeds/blocs/deeplink/model/deep_link_data.dart';
import 'package:seeds/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/blocs/deeplink/model/invite_link_data.dart';
import 'package:seeds/blocs/deeplink/model/region_link_data.dart';
import 'package:seeds/blocs/deeplink/usecase/get_initial_deep_link_use_case.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/domain-shared/shared_use_cases/get_signing_request_use_case.dart';
import 'package:uni_links/uni_links.dart';

part 'deeplink_event.dart';
part 'deeplink_state.dart';

class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
  StreamSubscription? _linkStreamSubscription;

  DeeplinkBloc() : super(DeeplinkState.initial()) {
    initDynamicLinks();
    initSigningRequests();
    on<HandleIncomingFirebaseDeepLink>(_handleIncomingFirebaseDeepLink);
    on<HandleIncomingSigningRequest>(_handleIncomingSigningRequest);
    on<OnGuardianRecoveryRequestSeen>((_, emit) => emit(state.copyWith()));
    on<ClearDeepLink>((_, emit) => emit(DeeplinkState.initial()));
  }

  @override
  Future<void> close() {
    _linkStreamSubscription?.cancel();
    return super.close();
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen(
      (pendingDynamicLinkData) {
        // Set up the `onLink` event listener next as it may be received here
        final Uri deepLink = pendingDynamicLinkData.link;
        // Example of using the dynamic link to push the user to a different screen
        add(HandleIncomingFirebaseDeepLink(deepLink));
        // }
      },
      onError: (error) async {},
    );

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
      print("ESR Error: $err");
    });
  }

  Future<void> _handleIncomingFirebaseDeepLink(
      HandleIncomingFirebaseDeepLink event, Emitter<DeeplinkState> emit) async {
    final DeepLinkData result = await GetInitialDeepLinkUseCase().run(event.newLink);

    emit(DeepLinkStateMapper().mapResultToState(state, result));
  }

  Future<void> _handleIncomingSigningRequest(HandleIncomingSigningRequest event, Emitter<DeeplinkState> emit) async {
    final result = await GetSigningRequestUseCase().run(event.link);
    emit(EosioSigningRequestStateMapper().mapSigningRequestToState(state, result));
  }
}
