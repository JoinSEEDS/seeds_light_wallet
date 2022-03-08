import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/regions_map/components/serach_places/view_models/search_places_bloc.dart';
import 'package:seeds/components/regions_map/interactor/view_models/place.dart';
import 'package:seeds/components/regions_map/interactor/view_models/regions_map_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

class SearchPlaces extends StatefulWidget {
  final ValueSetter<Place> onPlaceSelected;

  const SearchPlaces({Key? key, required this.onPlaceSelected}) : super(key: key);

  @override
  _SearchPlacesState createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {
  late SearchPlacesBloc _searchPlacesBloc;
  final TextEditingController queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchPlacesBloc = SearchPlacesBloc();
    queryController.addListener(() => _searchPlacesBloc.add(OnQueryTextChange(queryController.text)));
  }

  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _searchPlacesBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<SearchPlacesBloc, SearchPlacesState>(
            listenWhen: (_, current) => current.placeSelected != null,
            listener: (_, state) => widget.onPlaceSelected(state.placeSelected!),
          ),
        ],
        child: ListView(
          clipBehavior: Clip.none,
          children: [
            Card(
              color: AppColors.primary.withOpacity(0.5),
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: queryController,
                      autofocus: true,
                      style: Theme.of(context).textTheme.buttonWhiteL,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: Theme.of(context).textTheme.buttonLowEmphasis,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<RegionsMapBloc>(context).add(const ToggleSearchBar());
                        queryController.clear();
                      },
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<SearchPlacesBloc, SearchPlacesState>(
              builder: (context, state) {
                return state.predictions.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        color: AppColors.primary,
                        child: Column(
                          children: [
                            const PoweredByGoogleImage(),
                            if (state.showLinearIndicator)
                              Container(
                                  constraints: const BoxConstraints(maxHeight: 2.0),
                                  child: const LinearProgressIndicator())
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
            Container(
              color: AppColors.primary,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: BlocBuilder<SearchPlacesBloc, SearchPlacesState>(
                builder: (context, state) {
                  return state.predictions.isNotEmpty
                      ? ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            for (var i in state.predictions)
                              ListTile(
                                onTap: () => _searchPlacesBloc.add(OnPredictionSelected(i)),
                                leading: const Icon(Icons.location_on),
                                title: Text(
                                  i.description ?? '',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PoweredByGoogleImage extends StatelessWidget {
  const PoweredByGoogleImage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? "assets/images/google/powered_by_google_on_white.png"
                : "assets/images/google/powered_by_google_on_non_white.png",
            scale: 7,
          ),
        )
      ],
    );
  }
}
