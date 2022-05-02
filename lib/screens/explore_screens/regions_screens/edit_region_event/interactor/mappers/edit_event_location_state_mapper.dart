import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/regions_screens/edit_region_event/interactor/viewmodel/edit_region_event_bloc.dart';

class EditEventLocationStateMapper extends StateMapper {
  EditRegionEventState mapResultToState(EditRegionEventState currentState, Place newPlace) {
    final newGeoLocation = GeoPoint(
        double.parse(newPlace.lat.toStringAsPrecision(currentState.event.eventLocation.latitude.toString().length)),
        double.parse(newPlace.lng.toStringAsPrecision(currentState.event.eventLocation.longitude.toString().length)));

    if (newGeoLocation == currentState.event.eventLocation) {
      return currentState.copyWith(isSaveChangesButtonEnable: false);
    } else {
      return currentState.copyWith(isSaveChangesButtonEnable: true, newPlace: newPlace);
    }
  }
}
