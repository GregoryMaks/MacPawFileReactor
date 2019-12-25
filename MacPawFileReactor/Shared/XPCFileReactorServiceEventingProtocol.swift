//
//  XPCFileReactorServiceEventingProtocol.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

@objc(XPCFileReactorServiceEventingProtocol) protocol XPCFileReactorServiceEventingProtocol {
    
    func notify(operationsCompleted: UInt, from totalOperations: UInt)
    
}
