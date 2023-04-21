//
//  NetworkMonitor.swift
//  assessment-ios
//
//  Created by Luis Roberto Gutiérrez Carbajal on 20/04/23.
//

import Network
import Combine

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

protocol NavigationAvailable: ObservableObject {
    var isNavigationActive: Bool { get }
}

final class NetworkMonitor: NetworkMonitorProtocol, NavigationAvailable {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    private(set) var isConnected: Bool = false
    @Published var isNavigationActive: Bool = false

    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
    }

    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            DispatchQueue.main.async {
                self?.isNavigationActive = path.status != .unsatisfied
            }
        }
    }

    public func stopMonitoring() {
        monitor.cancel()
    }
}
