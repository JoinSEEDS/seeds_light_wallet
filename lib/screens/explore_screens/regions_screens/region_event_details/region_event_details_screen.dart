import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/components/flat_button_long.dart';
import 'package:seeds/datasource/remote/model/firebase_models/region_event_model.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/explore_screens/regions_screens/region_event_details/interactor/viewmodels/region_event_details_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class RegionEventDetailsScreen extends StatelessWidget {
  const RegionEventDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegionEventModel event = ModalRoute.of(context)!.settings.arguments! as RegionEventModel;
    final double width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => RegionEventDetailsBloc(),
      child: BlocListener<RegionEventDetailsBloc, RegionEventDetailsState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final command = state.pageCommand;
          BlocProvider.of<RegionEventDetailsBloc>(context).add(const ClearRegionEventPageCommand());
          if (command is LaunchRegionMapsLocation) {
            launch('https://www.google.com/maps/@${event.eventLocation.latitude},${event.eventLocation.longitude},17z');
          }
        },
        child: Scaffold(
          body: ListView(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(defaultCardBorderRadius),
                    bottomRight: Radius.circular(defaultCardBorderRadius),
                  ),
                ),
                height: width,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FittedBox(
                      clipBehavior: Clip.hardEdge,
                      fit: BoxFit.cover,
                      child: CachedNetworkImage(
                        imageUrl: event.eventImage,
                        errorWidget: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      right: 0,
                      child: Container(
                        width: width,
                        height: 80,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(left: 0, top: 0, right: 0, child: AppBar(backgroundColor: Colors.transparent)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event.formattedCreatedTime,
                          style: Theme.of(context).textTheme.subtitle2LowEmphasis,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11.0),
                            border: Border.all(color: AppColors.green3),
                          ),
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: AppColors.green3),
                              const SizedBox(width: 4.0),
                              Text(
                                '${event.formattedStartTime} - ${event.formattedEndTime}',
                                style: Theme.of(context).textTheme.subtitle3Green,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(children: [Text(event.eventName, style: Theme.of(context).textTheme.headline7)]),
                  ],
                ),
              ),
              const DividerJungle(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  children: [
                    Row(children: [Text('Details', style: Theme.of(context).textTheme.headline7)]),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 11.0),
                        Flexible(
                          child: InkWell(
                            onTap: () =>
                                BlocProvider.of<RegionEventDetailsBloc>(context).add(const OnRegionMapsLinkTapped()),
                            child: Text(
                              'https://www.google.com/maps/@${event.eventLocation.latitude},${event.eventLocation.longitude},17z',
                              style: Theme.of(context).textTheme.subtitle3,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            event.eventDescription,
                            style: Theme.of(context).textTheme.subtitle3OpacityEmphasis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: FlatButtonLong(title: "I'm Attending!", onPressed: () {}),
          ),
        ),
      ),
    );
  }
}
