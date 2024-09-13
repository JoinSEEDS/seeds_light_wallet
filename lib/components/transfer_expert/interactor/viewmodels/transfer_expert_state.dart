part of 'transfer_expert_bloc.dart';

class TransferExpertState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<ProfileModel> users;
  final bool showClearIcon;
  final List<String>? noShowUsers;
  final ProfileStatus? showOnlyCitizenshipStatus;
  final List<String>? authorizedAccounts;
  final Map<String, String?> selectedAccounts;
  final List<String> validChainAccounts;
  final String sendingToken;
  final String deliveryToken;

  const TransferExpertState({
    required this.pageState,
    this.errorMessage,
    required this.users,
    required this.showClearIcon,
    this.noShowUsers,
    this.showOnlyCitizenshipStatus,
    this.authorizedAccounts,
    required this.selectedAccounts,
    required this.validChainAccounts,
    required this.sendingToken,
    required this.deliveryToken,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        users,
        showClearIcon,
        noShowUsers,
        showOnlyCitizenshipStatus,
        authorizedAccounts,
        selectedAccounts,
        sendingToken,
        deliveryToken,
      ];

  TransferExpertState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<ProfileModel>? users,
    bool? showClearIcon,
    List<String>? noShowUsers,
    ProfileStatus? showOnlyCitizenshipStatus,
    List<String>? authorizedAccounts,
    Map<String, String?>? selectedAccounts,
    List<String>? validChainAccounts,
    String? sendingToken,
    String? deliveryToken,
  }) {
    return TransferExpertState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      users: users ?? this.users,
      showClearIcon: showClearIcon ?? this.showClearIcon,
      noShowUsers: noShowUsers ?? this.noShowUsers,
      showOnlyCitizenshipStatus: showOnlyCitizenshipStatus ?? this.showOnlyCitizenshipStatus,
      authorizedAccounts: authorizedAccounts ?? this.authorizedAccounts,
      selectedAccounts: selectedAccounts ?? this.selectedAccounts,
      validChainAccounts: validChainAccounts ?? this.validChainAccounts,
      sendingToken: sendingToken ?? this.sendingToken,
      deliveryToken: deliveryToken ?? this.deliveryToken,
    );
  }

  factory TransferExpertState.initial(List<String>? noShowUsers, ProfileStatus? filterByCitizenshipStatus) {
    return TransferExpertState(
      pageState: PageState.initial,
      users: [],
      showClearIcon: false,
      noShowUsers: noShowUsers,
      showOnlyCitizenshipStatus: filterByCitizenshipStatus,
      authorizedAccounts: [],
      selectedAccounts: {},
      validChainAccounts: [],
      sendingToken: settingsStorage.selectedToken.id,
      deliveryToken: settingsStorage.selectedToken.id,
    );
  }
}
