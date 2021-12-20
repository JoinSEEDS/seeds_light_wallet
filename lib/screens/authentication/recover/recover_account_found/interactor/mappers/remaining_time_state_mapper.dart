import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_bloc.dart';

///Seconds in a day
const int _daySecond = 60 * 60 * 24;

///Seconds in an hour
const int _hourSecond = 60 * 60;

///Seconds in a minute
const int _minuteSecond = 60;

class RemainingTimeStateMapper {
  RecoverAccountFoundState mapResultToState(RecoverAccountFoundState currentState) {
    int days = 0;
    int hours = 0;
    int min = 0;
    int remainingTimeStamp = currentState.timeRemaining;

    ///Calculate the number of days remaining.
    if (remainingTimeStamp >= _daySecond) {
      days = remainingTimeStamp ~/ _daySecond;
      remainingTimeStamp %= _daySecond;
    }

    ///Calculate remaining hours.
    if (remainingTimeStamp >= _hourSecond) {
      hours = remainingTimeStamp ~/ _hourSecond;
      remainingTimeStamp %= _hourSecond;
    } else if (days != 0) {
      hours = 0;
    }

    ///Calculate remaining minutes.
    if (remainingTimeStamp >= _minuteSecond) {
      min = remainingTimeStamp ~/ _minuteSecond;
      remainingTimeStamp %= _minuteSecond;
    } else if (hours != 0) {
      min = 0;
    }

    return currentState.copyWith(
      pageState: PageState.success,
      currentRemainingTime: CurrentRemainingTime(
        days: days,
        hours: hours,
        min: min,
        sec: remainingTimeStamp,
      ),
    );
  }
}
