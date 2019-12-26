//
//  CountHashOfFileOperation.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/26/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation
import CommonCrypto

class CountHashOfFileOperation: BaseReactorOperation {
    
    private (set) var resultHash: Data? = nil
    
    override func main() {
        if let fileData = FileManager.default.contents(atPath: path) {
            resultHash = sha256(for: fileData)
            addSomeFun()
        }
        else {
            resultHash = nil
        }
    }
    
    private func sha256(for data: Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    
}
