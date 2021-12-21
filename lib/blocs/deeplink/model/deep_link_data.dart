class DeepLinkData {
  final Map<String, dynamic> data;
  final DeepLinkPlaceHolder deepLinkPlaceHolder;

  DeepLinkData(this.data, this.deepLinkPlaceHolder);
}

enum DeepLinkPlaceHolder {
  linkGuardians,
  linkInvite,
  linkInvoice,
  linkUnknown,
}
