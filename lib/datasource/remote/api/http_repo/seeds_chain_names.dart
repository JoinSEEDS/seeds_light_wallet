const String _chainTelos = 'telos';
const String _chainTelosTest = 'telosTestnet';
const String _chainEos = 'eos';
const String _chainEosTest = 'eosTestnet';

enum SeedsChains {
  telos,
  telosTestnet,
  eos,
  eosTestnet,
}

extension SeedsChainsExtension on SeedsChains {
  String get value {
    switch (this) {
      case SeedsChains.telos:
        return _chainTelos;
      case SeedsChains.telosTestnet:
        return _chainTelosTest;
      case SeedsChains.eos:
        return _chainEos;
      case SeedsChains.eosTestnet:
        return _chainEosTest;
    }
  }
}
