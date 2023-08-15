import Reachability

class NetworkManager: NetworkManagerProtocol {
    private let reachability: Reachability

    init(reachability: Reachability) {
        self.reachability = reachability
    }

    var isNetworkAvailable: Bool {
        return reachability.connection != .unavailable
    }
}
