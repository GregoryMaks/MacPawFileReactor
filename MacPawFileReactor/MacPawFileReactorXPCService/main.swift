//
//  main.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

let delegate = ServiceDelegate()
let listener = NSXPCListener.service()

listener.delegate = delegate;
listener.resume()
