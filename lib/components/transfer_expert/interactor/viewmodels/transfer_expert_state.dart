part of 'transfer_expert_bloc.dart';

class TransferExpertState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<ProfileModel> users;
  final bool showClearIcon;
  final List<String>? noShowUsers;
  final ProfileStatus? showOnlyCitizenshipStatus;
  //final List<String>? authorizedAccounts;
  final Map<String, String?> selectedAccounts;
  final Map<String, EOSAccountModel?> accountPermissions;
  final List<String> validChainAccounts;
  final String sendingToken;
  final String deliveryToken;
  final TokenDataModel? swapSendAmount;
  final TokenDataModel? swapDeliverAmount;
  final PageCommand? pageCommand;
  final RatesState? ratesState;
  final bool showSendingAnimation;
  final String memo;

  const TransferExpertState({
    required this.pageState,
    this.errorMessage,
    required this.users,
    required this.showClearIcon,
    this.noShowUsers,
    this.showOnlyCitizenshipStatus,
    //this.authorizedAccounts,
    required this.accountPermissions,
    required this.selectedAccounts,
    required this.validChainAccounts,
    required this.sendingToken,
    required this.deliveryToken,
    this.swapSendAmount,
    this.swapDeliverAmount,
    this.pageCommand,
    this.ratesState,
    required this.showSendingAnimation,
    required this.memo,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        users,
        showClearIcon,
        noShowUsers,
        showOnlyCitizenshipStatus,
        //authorizedAccounts,
        accountPermissions,
        selectedAccounts,
        sendingToken,
        deliveryToken,
        swapSendAmount,
        swapDeliverAmount,
        pageCommand,
        ratesState,
        showSendingAnimation,
        memo,
      ];

  TransferExpertState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<ProfileModel>? users,
    bool? showClearIcon,
    List<String>? noShowUsers,
    ProfileStatus? showOnlyCitizenshipStatus,
    //List<String>? authorizedAccounts,
    Map<String, EOSAccountModel?>? accountPermissions,
    Map<String, String?>? selectedAccounts,
    List<String>? validChainAccounts,
    String? sendingToken,
    String? deliveryToken,
    TokenDataModel? swapSendAmount,
    TokenDataModel? swapDeliverAmount,
    PageCommand? pageCommand,
    RatesState? ratesState,
    bool? showSendingAnimation,
    String? memo,
  }) {
    return TransferExpertState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      users: users ?? this.users,
      showClearIcon: showClearIcon ?? this.showClearIcon,
      noShowUsers: noShowUsers ?? this.noShowUsers,
      showOnlyCitizenshipStatus: showOnlyCitizenshipStatus ?? this.showOnlyCitizenshipStatus,
      //authorizedAccounts: authorizedAccounts ?? this.authorizedAccounts,
      accountPermissions: accountPermissions ?? this.accountPermissions,
      selectedAccounts: selectedAccounts ?? this.selectedAccounts,
      validChainAccounts: validChainAccounts ?? this.validChainAccounts,
      sendingToken: sendingToken ?? this.sendingToken,
      deliveryToken: deliveryToken ?? this.deliveryToken,
      swapSendAmount: swapSendAmount ?? this.swapSendAmount,
      swapDeliverAmount: swapDeliverAmount ?? this.swapDeliverAmount,
      pageCommand: pageCommand ?? this.pageCommand,
      ratesState: ratesState ?? this.ratesState,
      showSendingAnimation: showSendingAnimation ?? this.showSendingAnimation,
      memo: memo ?? this.memo,
    );
  }

  factory TransferExpertState.initial(List<String>? noShowUsers, ProfileStatus? filterByCitizenshipStatus,) {
    return TransferExpertState(
      pageState: PageState.initial,
      users: [],
      showClearIcon: false,
      noShowUsers: noShowUsers,
      showOnlyCitizenshipStatus: filterByCitizenshipStatus,
      //authorizedAccounts: [],
      accountPermissions: {},
      selectedAccounts: {},
      validChainAccounts: [],
      sendingToken: settingsStorage.selectedToken.id,
      deliveryToken: settingsStorage.selectedToken.id,
      swapSendAmount: TokenDataModel(0, token: settingsStorage.selectedToken),
      swapDeliverAmount: TokenDataModel(0, token: settingsStorage.selectedToken),
      showSendingAnimation: false,
      memo: "",
    );
  }
}
