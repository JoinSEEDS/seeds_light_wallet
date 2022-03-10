import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seeds/components/regions_map/components/regions_serach_bar.dart';
import 'package:seeds/components/regions_map/interactor/view_models/regions_map_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/page_state.dart';

class RegionsMap extends StatefulWidget {
  const RegionsMap({Key? key}) : super(key: key);

  @override
  _RegionsMapState createState() => _RegionsMapState();
}

class _RegionsMapState extends State<RegionsMap> {
  late final RegionsMapBloc _regionsMapBloc;
  GoogleMapController? _mapController;

  @override
  void initState() {
    _regionsMapBloc = RegionsMapBloc()..add(const SetInitialValues());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _regionsMapBloc,
      child: BlocConsumer<RegionsMapBloc, RegionsMapState>(
        listenWhen: (previous, current) => previous.moveCamera == false && current.moveCamera == true,
        listener: (context, state) {
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(state.newPlace.lat, state.newPlace.lng), zoom: 15),
            ),
          );
        },
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.success:
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GoogleMap(
                        gestureRecognizers: {
                          Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (controller) => _mapController = controller,
                        initialCameraPosition:
                            CameraPosition(target: LatLng(state.newPlace.lat, state.newPlace.lng), zoom: 15),
                        onCameraMove: (p) {
                          _regionsMapBloc
                              .add(OnMapMoving(pickedLat: p.target.latitude, pickedLong: p.target.longitude));
                        },
                        onCameraIdle: () => _regionsMapBloc.add(const OnMapEndMove()),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: state.markerStatus == MarkerStatus.moving
                          ? const Icon(
                              Icons.location_off,
                              color: AppColors.primary,
                              size: 36,
                            )
                          : SvgPicture.asset('assets/images/explore/marker_location.svg'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: IconButton(
                        color: Colors.transparent,
                        onPressed: () => _regionsMapBloc.add(const MoveToCurrentLocation()),
                        icon: const Icon(Icons.my_location, size: 38.0, color: AppColors.darkGreen2),
                      ),
                    ),
                  ),
                  if (state.markerStatus == MarkerStatus.initial) const RegionsSearchBar(),
                ],
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
