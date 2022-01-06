enum TransactionResultStatus { success, canceled, failure }

class TransactionResult {
  final TransactionResultStatus status;

  /// message can have the transacction id (success)
  /// or the error description (failure)
  final String message;

  const TransactionResult({this.status = TransactionResultStatus.canceled, this.message = ''});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
