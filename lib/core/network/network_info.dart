abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class DefaultNetworkInfo implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

///search for this part in future if you want to implement network connectivity
// import 'package:connectivity_plus/connectivity_plus.dart';

// class NetworkInfo {
//   final Connectivity connectivity;

//   NetworkInfo(this.connectivity);

//   Future<bool> get isConnected async {
//     final result = await connectivity.checkConnectivity();

//     return !result.contains(ConnectivityResult.none);
//   }
// }

// connectivity_plus mainly tells us network connectivity. A request can still fail.
//  It does not actually check the internet yet. A future connectivity_plus implementation could provide a real connectivity signal, though a connection can still fail even when a network is available.
