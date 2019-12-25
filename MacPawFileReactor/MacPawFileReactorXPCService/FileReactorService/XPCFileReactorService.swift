//
//  FileReactorService.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class XPCFileReactorService: XPCFileReactorServiceProtocol {
    
    public func removeFiles(atURLs: [URL], withReply reply: @escaping ([Bool]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            reply([])
        }
    }
    
    public func duplicateFiles(atURLs: [URL], withReply reply: @escaping ([Bool]) -> Void) {
        // TODO
    }
    
    public func countHashSumOfFiles(atURLs: [URL], withReply reply: @escaping () -> Void) {
        // TODO
    }
    
}
