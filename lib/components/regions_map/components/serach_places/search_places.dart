import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/regions_map/components/serach_places/interactor/view_models/search_places_bloc.dart';
import 'package:seeds/components/regions_map/interactor/view_models/regions_map_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/images/explore/regions.dart';

class SearchPlaces extends StatelessWidget {
  const SearchPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchPlacesBloc(BlocProvider.of<RegionsMapBloc>(context).state.regions),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SearchPlacesBloc, SearchPlacesState>(
            listenWhen: (_, current) => current.placeSelected != null,
            listener: (_, state) {
              BlocProvider.of<RegionsMapBloc>(context).add(OnPlaceResultSelected(state.placeSelected!));
            },
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
                    child: Builder(builder: (context) {
                      return TextField(
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
                        onChanged: (value) {
                          BlocProvider.of<SearchPlacesBloc>(context).add(OnQueryTextChange(value));
                        },
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => BlocProvider.of<RegionsMapBloc>(context).add(const ToggleSearchBar()),
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
                      ? ListView.builder(
                          clipBehavior: Clip.none,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: state.predictions.length,
                          itemBuilder: (_, index) {
                            final item = state.predictions[index];
                            final isRegion = item.description.contains('.rgn');
                            return ListTile(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                BlocProvider.of<SearchPlacesBloc>(context).add(OnPredictionSelected(item));
                              },
                              leading: isRegion
                                  ? const CustomPaint(size: Size(24, 24), painter: Regions())
                                  : const Icon(Icons.location_on),
                              title: Text(
                                item.description,
                                overflow: TextOverflow.ellipsis,
                                style: isRegion ? Theme.of(context).textTheme.subtitle2Green3LowEmphasis : null,
                              ),
                            );
                          },
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
  const PoweredByGoogleImage({super.key});
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
