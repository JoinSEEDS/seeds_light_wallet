import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/components/divider_jungle.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/profile_screens/profile/components/citizenship_card.dart';
import 'package:seeds/screens/profile_screens/profile/components/profile_bottom.dart';
import 'package:seeds/screens/profile_screens/profile/components/profile_header.dart';
import 'package:seeds/screens/profile_screens/profile/components/profile_middle.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/switch_account_bottom_sheet.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/profile/interactor/viewmodels/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => ProfileBloc(remoteConfigurations.featureFlagImportAccountEnabled)..add(LoadProfileValues()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          final pageCommand = state.pageCommand;
          BlocProvider.of<ProfileBloc>(context).add(const ClearProfilePageCommand());
          if (pageCommand is ShowSwitchAccount) {
            const SwithAccountBottomSheet().show(context);
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: InkWell(
                  onTap: () => BlocProvider.of<ProfileBloc>(context).add(const OnSwitchAccountButtonTapped()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text(settingsStorage.accountName), const Icon(Icons.keyboard_arrow_down)],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: SvgPicture.asset('assets/images/wallet/app_bar/scan_qr_code_icon.svg'),
                    onPressed: () => NavigationService.of(context).navigateTo(Routes.scanQRCode),
                  ),
                ],
              ),
              body: BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                    previous.profile != current.profile || previous.isOrganization != current.isOrganization,
                builder: (context, state) {
                  final components = [
                    const ProfileHeader(),
                    const DividerJungle(thickness: 2),
                    const ProfileMiddle(),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: DividerJungle(thickness: 2)),
                    const SizedBox(height: 16.0),
                    const ProfileBottom(),
                  ];
                  if (state.showCitizenCard) {
                    components.insert(5, const CitizenshipCard());
                  }

                  return RefreshIndicator(
                    onRefresh: () async => BlocProvider.of<ProfileBloc>(context).add(LoadProfileValues()),
                    child: ListView(children: components),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
