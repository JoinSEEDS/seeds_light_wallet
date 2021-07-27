class DeepLinkData {
  final Map<String, dynamic> data;
  final DeepLinkPlaceHolder deepLinkPlaceHolder;

  DeepLinkData(
    this.data,
    this.deepLinkPlaceHolder,
  );
}

enum DeepLinkPlaceHolder {
  LINK_GUARDIANS,
  LINK_INVITE,
  LINK_UNKNOWN,
}
