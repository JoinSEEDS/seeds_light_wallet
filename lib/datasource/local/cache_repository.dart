import 'package:hive/hive.dart';

// Hive box names

const String proposalVotesCacheBox = 'proposalVotesBox';
const String membersCacheBox = 'membersBox';

/// Vote cache needs to support multiple accounts.
/// The vote cache needs to store what account the vote was for.
///
String buildVoteKey(String account, int proposalId) => '${account}_$proposalId';

class CacheRepository<T> {
  final Box _box;

  const CacheRepository(Box box) : _box = box;

  bool get boxIsClosed => !_box.isOpen;

  T? get(dynamic id) {
    if (boxIsClosed) {
      return null;
    }
    return _box.get(id);
  }

  Future<void> add(dynamic id, T object) async {
    if (boxIsClosed) {
      return;
    }
    await _box.put(id, object);
  }
}
