import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

part 'sponsor_event.dart';
part 'sponsor_state.dart';

class SponsorBloc extends Bloc<SponsorEvent, SponsorState> {
  SponsorBloc() : super(SponsorState.initial()) {
    on<LoadUserSponsorList>(_loadUserSponsorList);
  }

  //To be finish on next pr
  Future<void> _loadUserSponsorList(LoadUserSponsorList event, Emitter<SponsorState> emit) async {
    emit(state.copyWith(pageState: PageState.success));
  }
}
