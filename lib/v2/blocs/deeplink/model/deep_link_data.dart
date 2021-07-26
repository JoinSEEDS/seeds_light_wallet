class DeepLinkData {
  final Map<String, dynamic> data;
  final DeepLinkPlaceHolder deepLinkPlaceHolder;
  final String guardianAccount;

  DeepLinkData(
    this.data,
    this.deepLinkPlaceHolder,
    this.guardianAccount,
  );
}

enum DeepLinkPlaceHolder {
  LINK_GUARDIANS,
  LINK_INVITE,
  LINK_UNKNOWN,
}
