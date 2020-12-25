import './export.dart';

class JoinProcessOverlay extends StatefulWidget {
  @override
  _JoinProcessOverlayState createState() => _JoinProcessOverlayState();
}

class _JoinProcessOverlayState extends State<JoinProcessOverlay>
    with SingleTickerProviderStateMixin {
  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return AnimatedSize(
      vsync: this,
      duration: Duration(milliseconds: 150),
      curve: Curves.fastOutSlowIn,
      child: Container(
        width: width,
        height: height * topSize(),
        padding: EdgeInsets.only(
            left: width * 0.23,
            right: width * 0.23,
            top: MediaQuery.of(context).padding.top,
            bottom: 30),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.32],
                colors: AppColors.gradient)),
        child: Image(
          image: AssetImage('assets/images/logo_title_white.png'),
        ),
      ),
    );
  }

  double topSize() {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return keyboardSpace > 33 ? 0.25 : 0.35;
  }

  Widget buildCard() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      margin: EdgeInsets.only(top: height * topSize() - 30),
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          buildBackButton(),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return BlocBuilder<OnboardingBloc, OnboardingState>(builder: (_, state) {
      print('rebuild body');

      switch (state.step) {
        case Step.onboardingMethodChoice:
          return ShowOnboardingChoice(
            onInvite: () =>
                context.read<OnboardingBloc>().add(ChosenClaimInvite()),
            onImport: () =>
                context.read<OnboardingBloc>().add(ChosenImportAccount()),
            onRecover: () =>
                context.read<OnboardingBloc>().add(ChosenRecoverAccount()),
          );
        case Step.claimInviteCode:
          return ClaimCode(
            inviteCode: state.inviteCode,
            onClaim: ({inviteSecret, inviterAccount}) {
              context.read<OnboardingBloc>().add(ClaimInviteRequested()
                ..inviteSecret = inviteSecret
                ..inviterAccount = inviterAccount);
            },
          );
        case Step.createAccountEnterName:
          return CreateAccount(
            inviteSecret: state.inviteSecret,
            initialName: state.nickname,
            onSubmit: (nickname) => context
                .read<OnboardingBloc>()
                .add(CreateAccountNameEntered()..nickname = nickname),
          );
        case Step.createAccountAccountName:
          return CreateAccountAccountName(
            nickname: state.nickname,
            onSubmit: (accountName, nickname) {
              context.read<OnboardingBloc>().add(CreateAccountRequestedFinal()
                ..accountName = accountName
                ..nickname = nickname);
            },
          );
        case Step.importAccount:
          return ImportAccount(onImport: ({accountName, privateKey}) {
            context.read<OnboardingBloc>().add(ImportAccountRequested()
              ..accountName = accountName
              ..privateKey = privateKey);
          });
        case Step.startRecovery:
          return RequestRecovery(
            onRequestRecovery: (String accountName) {
              context
                  .read<OnboardingBloc>()
                  .add(StartRecoveryRequested()..accountName = accountName);
            },
          );
        case Step.continueRecovery:
          return ContinueRecovery(
            accountName: state.accountName,
            privateKey: state.privateKey,
            onClaimed: () =>
                context.read<OnboardingBloc>().add(ClaimRecoveredAccount()),
            onBack: () => context.read<OnboardingBloc>().add(BackPressed()),
          );
        default:
          return NotionLoader(
            notion: state.loaderNotion,
          );
      }
    });
  }

  Widget buildBackButton() {
    return Hero(
      tag: 'header',
      child: Container(
        padding: EdgeInsets.only(left: 7, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
                onTap: () => context.read<OnboardingBloc>().add(BackPressed()),
                child: Icon(Icons.arrow_back)),
            InkWell(
              onTap: () => context.read<OnboardingBloc>().add(BackPressed()),
              child: Text(
                "Back".i18n,
                style: TextStyle(
                    fontFamily: "worksans",
                    fontSize: 17,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            buildHeader(),
            buildCard(),
          ],
        ),
      ),
    );
  }
}
