abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class DefaultNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}
