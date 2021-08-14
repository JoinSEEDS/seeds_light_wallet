class CacheKeys {
  static String proposalVotesCacheName = "votes.2.box";
  static String voteCacheKey(String account, int proposalId) {
    return "${account}_$proposalId";
  }  
}
