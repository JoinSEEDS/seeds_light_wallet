import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/firebase/regions/firebase_database_regions_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_message_model.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'region_event.dart';

part 'region_state.dart';

class RegionBloc extends Bloc<RegionEvent, RegionState> {
  final String regionAccount;

  RegionBloc(this.regionAccount) : super(RegionState.initial());


  Stream<List<RegionMessageModel>> get regionMessages =>
      FirebaseDatabaseRegionsRepository().getMessagesForRegion(regionAccount);
}
