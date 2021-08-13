import 'package:collection/collection.dart' show IterableExtension;
import 'package:seeds/v2/datasource/remote/model/moon_phase_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/vote_state.dart';
import 'package:seeds/v2/i18n/explore_screens/vote/vote.i18n.dart';

const String _new_moon = 'New Moon';

class NextMoonPhaseStateMapper extends StateMapper {
  VoteState mapResultToState(VoteState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error loading next moon cycle'.i18n);
    } else {
      final List<MoonPhaseModel> moonPhases = result.asValue!.value;

      final MoonPhaseModel? nextNewMoon = moonPhases.singleWhereOrNull((i) => i.phaseName == _new_moon);

      final int remainingTimeStamp = DateTime.parse(nextNewMoon!.time).toLocal().millisecondsSinceEpoch;

      return currentState.copyWith(remainingTimeStamp: remainingTimeStamp);
    }
  }
}
