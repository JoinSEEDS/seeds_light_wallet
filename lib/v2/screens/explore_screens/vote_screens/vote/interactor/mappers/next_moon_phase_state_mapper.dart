import 'package:async/async.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/v2/datasource/remote/model/moon_phase_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/vote_state.dart';

const _new_moon = 'New Moon';

class NextMoonPhaseStateMapper {
  VoteState mapResultToState(VoteState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error loading next moon cycle');
    } else {
      List<MoonPhaseModel> moonPhases = result.asValue!.value;

      MoonPhaseModel? nextNewMoon = moonPhases.singleWhereOrNull((i) => i.phaseName == _new_moon);

      int remainingTimeStamp = DateTime.parse(nextNewMoon!.time).toLocal().millisecondsSinceEpoch;

      return currentState.copyWith(remainingTimeStamp: remainingTimeStamp);
    }
  }
}
