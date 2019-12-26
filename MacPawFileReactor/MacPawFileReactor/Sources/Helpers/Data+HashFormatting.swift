//
//  Data+HashFormatting.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/26/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

extension Data {
    
    var hashString: String {
        self.map { String(format: "%02hhx", $0) }.joined().uppercased()
    }
    
}
