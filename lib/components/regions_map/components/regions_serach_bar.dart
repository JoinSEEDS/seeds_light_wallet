import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/regions_map/components/serach_places/search_places.dart';
import 'package:seeds/components/regions_map/interactor/view_models/regions_map_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';

class RegionsSearchBar extends StatelessWidget {
  const RegionsSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegionsMapBloc, RegionsMapState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () => BlocProvider.of<RegionsMapBloc>(context).add(const ToggleSearchBar()),
              child: state.isSearchingPlace
                  ? SearchPlaces(
                      onPlaceSelected: (place) {
                        BlocProvider.of<RegionsMapBloc>(context).add(OnPlaceResultSelected(place));
                      },
                    )
                  : Card(
                      color: AppColors.primary.withOpacity(0.5),
                      child: Row(
                        children: [
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text(state.newPlace.placeText, style: Theme.of(context).textTheme.buttonWhiteL),
                          ),
                          const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.search)),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
