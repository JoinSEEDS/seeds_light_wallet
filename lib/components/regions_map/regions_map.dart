import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seeds/components/regions_map/components/serach_places/search_places.dart';
import 'package:seeds/components/regions_map/interactor/view_models/page_commands.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/components/regions_map/interactor/view_models/regions_map_bloc.dart';
import 'package:seeds/datasource/remote/model/region_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';

class RegionsMap extends StatefulWidget {
  final ValueSetter<Place>? onPlaceChanged;
  final Widget? bottomWidget;
  final List<RegionModel>? regions;

  const RegionsMap({Key? key, this.onPlaceChanged, this.bottomWidget, this.regions}) : super(key: key);

  @override
  _RegionsMapState createState() => _RegionsMapState();
}

class _RegionsMapState extends State<RegionsMap> with WidgetsBindingObserver {
  late final RegionsMapBloc _regionsMapBloc;
  GoogleMapController? _mapController;
  double lat = 0;
  double lng = 0;

  @override
  void initState() {
    _regionsMapBloc = RegionsMapBloc(widget.regions)..add(const SetInitialValues());
    super.initState();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Fix for bug https://github.com/flutter/flutter/issues/40284
    if (state == AppLifecycleState.resumed) {
      _mapController!.setMapStyle("[]");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _regionsMapBloc,
      child: BlocConsumer<RegionsMapBloc, RegionsMapState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          _regionsMapBloc.add(const ClearRegionsMapPageCommand());
          if (pageCommand is MoveCamera) {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(state.newPlace.lat, state.newPlace.lng), zoom: 15),
              ),
            );
            widget.onPlaceChanged?.call(state.newPlace);
          } else if (pageCommand is MoveCameraStop) {
            widget.onPlaceChanged?.call(state.newPlace);
          }
        },
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.success:
              return Stack(
                children: [
                  // Set maximum size for fisrt widget
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(children: [
                      Expanded(flex: 5, child: Container()),
                      if (widget.bottomWidget != null) Expanded(flex: 3, child: widget.bottomWidget!)
                    ]),
                  ),
                  // Map
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Stack(
                        children: [
                          GoogleMap(
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                            },
                            mapToolbarEnabled: false,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            onMapCreated: (controller) => _mapController = controller,
                            initialCameraPosition:
                                CameraPosition(target: LatLng(state.newPlace.lat, state.newPlace.lng), zoom: 15),
                            onCameraMove: (p) {
                              // These vars are to void rebuild map for each different lat, lng
                              // Also to avoid fire a new place instance on moving
                              lat = p.target.latitude;
                              lng = p.target.longitude;
                              if (!state.isCameraMoving) {
                                _regionsMapBloc.add(const OnMapMoving());
                              }
                            },
                            onCameraIdle: () => _regionsMapBloc.add(OnMapEndMove(pickedLat: lat, pickedLong: lng)),
                            markers: Set.from(
                              state.regions
                                  .map((i) => Marker(
                                        markerId: MarkerId(i.id),
                                        position: LatLng(i.latitude, i.longitude),
                                        infoWindow: InfoWindow(title: i.title),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: state.isCameraMoving
                                  ? const Icon(Icons.location_off, color: AppColors.primary, size: 36)
                                  : SvgPicture.asset('assets/images/explore/marker_location.svg'),
                            ),
                          ),
                          if (state.isUserLocationEnabled)
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
                        ],
                      ),
                    ),
                  ),
                  // Search Bar
                  if (!state.isCameraMoving)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        onTap: () => BlocProvider.of<RegionsMapBloc>(context).add(const ToggleSearchBar()),
                        child: state.isSearchingPlace
                            ? const SearchPlaces()
                            : Card(
                                color: AppColors.primary.withOpacity(0.5),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Text(state.newPlace.placeText,
                                          style: Theme.of(context).textTheme.buttonWhiteL),
                                    ),
                                    const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.search)),
                                  ],
                                ),
                              ),
                      ),
                    ),
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
