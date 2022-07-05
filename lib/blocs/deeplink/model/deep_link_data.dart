class DeepLinkData {
  final Map<String, dynamic> data;
  final DeepLinkPlaceHolder deepLinkPlaceHolder;

  const DeepLinkData(this.data, this.deepLinkPlaceHolder);
}

enum DeepLinkPlaceHolder { guardian, invite, invoice, region, unknown }
