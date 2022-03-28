import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/design/app_theme.dart';
import 'package:seeds/domain-shared/ui_constants.dart';
import 'package:seeds/screens/profile_screens/support/interactor/viewmodels/support_bloc.dart';
import 'package:seeds/utils/build_context_extension.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportBloc()..add(const LoadSupportData()),
      child: BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(context.loc.supportTitle)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(defaultCardBorderRadius),
                    onTap: () async => launch('https://discord.gg/pSWdqxTjvB'),
                    child: Ink(
                      decoration: const BoxDecoration(
                        color: AppColors.lightGreen2,
                        borderRadius: BorderRadius.all(Radius.circular(defaultCardBorderRadius)),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(defaultCardBorderRadius),
                                ),
                                child: SvgPicture.asset(
                                  "assets/images/lotus_support_small.svg",
                                  color: AppColors.canopy,
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  const SizedBox(height: 50),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(defaultCardBorderRadius),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/images/lotus_support_big.svg",
                                      color: AppColors.canopy,
                                      alignment: Alignment.bottomRight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0, bottom: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 80.0),
                                  child: Text(
                                    context.loc.supportDiscordChannelPart1,
                                    style: Theme.of(context).textTheme.buttonLowEmphasis,
                                  ),
                                ),
                                Text(
                                  context.loc.supportDiscordChannelPart2,
                                  style: Theme.of(context).textTheme.headline8.copyWith(color: AppColors.canopy),
                                ),
                                const SizedBox(height: 8.0),
                                RichText(
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.buttonLowEmphasis,
                                    children: <TextSpan>[
                                      TextSpan(text: context.loc.supportDiscordChannelPart3),
                                      TextSpan(
                                          text: context.loc.supportDiscordChannelPart4,
                                          style: Theme.of(context)
                                              .textTheme
                                              .buttonLowEmphasis
                                              .copyWith(color: AppColors.canopy)),
                                      TextSpan(text: context.loc.supportDiscordChannelPart5),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(state.appName ?? ""),
                  const SizedBox(height: 6),
                  Text("${state.version}(${state.buildNumber})"),
                  const SizedBox(height: 6),
                  Text(state.firebaseInstallationId ?? ""),
                  const SizedBox(height: 6),
                  MaterialButton(
                    onPressed: () => Share.share(
                        "${state.appName}, ${state.version} (${state.buildNumber}), ${state.firebaseInstallationId}"),
                    color: AppColors.green1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    child: Text(context.loc.supportTapToShare),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
