import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/mappers/update_profile_state_mapper.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/usecases/update_profile_use_case.dart';
import 'package:seeds/screens/profile_screens/edit_name/interactor/viewmodels/page_state.dart';

part 'edit_name_bloc.freezed.dart';

part 'edit_name_event.dart';

part 'edit_name_state.dart';

part 'edit_name_state_data.dart';

part 'page_command.dart';

const nameMaxChars = 42;

class EditNameBloc extends Bloc<EditNameEvent, Union<EditNameStateData>> {
  EditNameBloc(ProfileModel profileModel)
      : super(Union(EditNameStateData(profileModel: profileModel, name: profileModel.nickname))) {
    on<_OnNameChanged>(_onNameChange);
    // on<_SubmitName>(_submitName);
    // on<_ClearPageCommand>((event, emit) => emit(state.copyWith()));
  }

// Future<void> _submitName(_SubmitName event, Emitter<Union<EditNameStateData>> emit) async {
//   state.maybeWhen((EditNameStateData value) => doThis(value), orElse: (){});
//
//   if (state.profileModel.nickname != state.name) {
//     emit(state.copyWith(pageState: PageState.loading));
//     final result = await UpdateProfileUseCase().run(newName: state.name, profile: state.profileModel);
//     emit(UpdateProfileStateMapper().mapResultToState(state, result));
//   }
// }
//
FutureOr<void> _onNameChange(_OnNameChanged event, Emitter<Union<EditNameStateData>> emit) {

    if(state is Data) {

      emit(state.);
    }



    state.whenOrNull((EditNameStateData data)  {
    emit(state.data.copyWith(name: event.name));
  });
//
//   emit(state.copyWith(name: event.name));
//   if (event.name.length > nameMaxChars) {
//     emit(state.copyWith(errorMessage: "Max length is $nameMaxChars characters"));
//   } else if (event.name.isEmpty) {
//     emit(state.copyWith(errorMessage: "Name cannot be empty"));
//   }
// }
//
// doThis(EditNameStateData value) {
//   if (value.profileModel.nickname != value.name) {
//     emit(value.copyWith(pageState: PageState.loading));
//     final result = await UpdateProfileUseCase().run(newName: state.name, profile: state.profileModel);
//     emit(UpdateProfileStateMapper().mapResultToState(state, result));
//   }
// }
}
