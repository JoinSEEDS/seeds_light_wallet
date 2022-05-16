import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/components/full_page_error_indicator.dart';
import 'package:seeds/components/full_page_loading_indicator.dart';
import 'package:seeds/components/member_info_row.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/explore_screens/vouch/sponsor_tab/interactor/viewmodels/sponsor_bloc.dart';

class SponsorTab extends StatelessWidget {
  const SponsorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SponsorBloc()..add(const LoadUserSponsorList()),
      child: BlocBuilder<SponsorBloc, SponsorState>(
        builder: (context, state) {
          switch (state.pageState) {
            case PageState.loading:
              return const FullPageLoadingIndicator();
            case PageState.failure:
              return const FullPageErrorIndicator();
            case PageState.success:
              return Scaffold(
                body: SafeArea(
                  minimum: const EdgeInsets.all(horizontalEdgePadding),
                  child: state.sponsors.isEmpty
                      ? Center(
                          child: Text(
                            'No one has vouched for you',
                            style: Theme.of(context).textTheme.buttonLowEmphasis,
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.only(top: 10),
                          children: [for (final i in state.sponsors) MemberInfoRow(i)],
                        ),
                ),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
