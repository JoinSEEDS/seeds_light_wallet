enum TransactionResultStatus { success, canceled, failure }

/// The payload that is sent to the P2P app
/// as a result of a transaction operation.
class TransactionResult {
  final TransactionResultStatus status;

  /// [message] can have:
  /// -The transacction id (success)
  /// -The error description (failure)
  /// -The canceled text (canceled/default)
  final String message;

  const TransactionResult({this.status = TransactionResultStatus.canceled, this.message = 'Canceled by the user.'});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
