import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/images/vote/proposal_category.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';

class ProposalDetailsHeader extends StatelessWidget {
  const ProposalDetailsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        return Container(
          height: 280,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: CachedNetworkImage(
                  imageUrl: state.proposals[state.currentIndex].image,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              Positioned(left: 0, top: 0, right: 0, child: AppBar(backgroundColor: Colors.transparent)),
              Positioned(
                top: kToolbarHeight + 42,
                left: 0,
                child: CustomPaint(
                  size: const Size(82, 22),
                  painter: const ProposalCategory(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(state.proposals[state.currentIndex].campaignTypeLabel,
                        style: Theme.of(context).textTheme.subtitle3OpacityEmphasis),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
