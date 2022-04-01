import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_message_model.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/regions_screens/regions_main/interactor/usecases/join_region_use_case.dart';

part 'region_event.dart';

part 'region_state.dart';

class RegionBloc extends Bloc<RegionEvent, RegionState> {
  RegionBloc(RegionModel? region) : super(RegionState.initial(region)) {
    on<OnJoinRegionButtonPressed>(_onJoinRegionButtonPressed);
  }

  Stream<List<RegionMessageModel>> get regionMessages =>
      FirebaseDatabaseRegionsRepository().getMessagesForRegion(state.region!.id);

  Future<void> _onJoinRegionButtonPressed(OnJoinRegionButtonPressed event, Emitter<RegionState> emit) async {
    // lauch confirm dialog after confirm execute this code below
    emit(state.copyWith(pageState: PageState.loading));
    final result = await JoinRegionUseCase()
        .run(JoinRegionUseCase.input(region: event.regionId, userAccount: settingsStorage.accountName));
    if (result.isError) {
      emit(state.copyWith(pageState: PageState.failure));
    } else {
      // Success change view mode to main
    }
  }
}
