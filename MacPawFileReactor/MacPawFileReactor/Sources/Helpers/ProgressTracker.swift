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
    
    private(set) var totalOperationCount: UInt = 0
    private(set) var operationsCompleted: UInt = 0
    
    public var progressDidChange: (ProgressHandler)?
    
    public init(totalOperationCount: UInt) {
        self.totalOperationCount = totalOperationCount
    }
    
    public func incrementCompletedOperations(by increment: UInt) {
        operationsCompleted = min(operationsCompleted + increment, totalOperationCount)
        notifyProgressChanged()
    }
    
    public func markAsFullyCompleted() {
        operationsCompleted = totalOperationCount
        notifyProgressChanged()
    }
    
}

// MARK: - Private methods

extension ProgressTracker {
    
    func notifyProgressChanged() {
        let fractionCompleted = Double(operationsCompleted) / Double(totalOperationCount)
        progressDidChange?(fractionCompleted)
    }
    
}
