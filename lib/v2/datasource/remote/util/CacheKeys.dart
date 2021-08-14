class CacheKeys {
  static String voteCacheKey(String account, int proposalId) {
    return "${account}_$proposalId";
  }  
}
