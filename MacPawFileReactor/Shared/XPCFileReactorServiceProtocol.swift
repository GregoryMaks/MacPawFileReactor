//
//  MacPawFileReactorXPCServiceProtocol.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

public let XPCFileReactorServiceName = "com.gregorymaks.MacPawFileReactor.XPCFileReactorService"

@objc(FileReactorServiceProtocol) protocol XPCFileReactorServiceProtocol {
    
    func removeFiles(atPaths paths: [String], withReply reply: @escaping ([Bool]) -> Void)
    func duplicateFiles(atPaths paths: [String], withReply reply: @escaping ([Bool]) -> Void)
    func countHashSumOfFiles(atPaths paths: [String], withReply reply: @escaping () -> Void)
    
}
