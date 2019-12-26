//
//  ProgressTracker.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class ProgressTracker {
    
    typealias ProgressHandler = (_ fractionCompleted: Double) -> Void
    
    private var syncQueue: DispatchQueue = DispatchQueue(
        label: "com.gregorymaks.MacPawFileReactor.ProgressTracker.syncQueue",
        qos: DispatchQoS.default,
        attributes: [],
        autoreleaseFrequency: .workItem,
        target: nil)
    
    private(set) var totalOperationCount: UInt = 0
    private(set) var operationsCompleted: UInt = 0
    
    public var progressDidChange: (ProgressHandler)?
    
    public init(totalOperationCount: UInt) {
        self.totalOperationCount = totalOperationCount
    }
    
    public func updateCompletedOperations(to operationsCompleted: UInt) {
        syncQueue.async {
            let operationsCompleted = max(operationsCompleted, self.operationsCompleted)
            self.operationsCompleted = min(operationsCompleted, self.totalOperationCount)
            self.notifyProgressChanged()
        }
    }
    
    public func incrementCompletedOperations(by increment: UInt) {
        syncQueue.async {
            self.operationsCompleted = min(self.operationsCompleted + increment, self.totalOperationCount)
            self.notifyProgressChanged()
        }
    }
    
    public func markAsFullyCompleted() {
        syncQueue.async {
            self.operationsCompleted = self.totalOperationCount
            self.notifyProgressChanged()
        }
    }
    
}

// MARK: - Private methods

extension ProgressTracker {
    
    func notifyProgressChanged() {
        let fractionCompleted = Double(operationsCompleted) / Double(totalOperationCount)
        progressDidChange?(fractionCompleted)
    }
    
}
