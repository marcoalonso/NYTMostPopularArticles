//
//  NetworkMonitor.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import Foundation
import Network
import Combine

/// A class that monitors the network connectivity status.
///
/// The `NetworkMonitor` class uses `NWPathMonitor` to observe changes in the device's network connectivity.
/// It updates the `isConnected` property to reflect the current connectivity status.
///
/// - Note: This class is observable and can be used to reactively display connectivity status.
class NetworkMonitor: ObservableObject {
    /// The network path monitor responsible for tracking the network status.
    private let monitor = NWPathMonitor()
    
    /// The dispatch queue where the network monitoring occurs.
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    /// A published property that indicates whether the device is connected to the internet.
    ///
    /// - `true`: The device has an active internet connection.
    /// - `false`: The device does not have an active internet connection.
    @Published var isConnected: Bool = true

    /// Initializes the `NetworkMonitor` and starts monitoring the network path.
    ///
    /// The class sets up a path update handler to listen for changes in the network connectivity status.
    /// When the status changes, it updates the `isConnected` property on the main thread.
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
