//
//  FileProcessingUserResult.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

enum FileProcessingResult {
    case noItemsToProcess
    case success(_ customResult: String?)
    case partialSuccess
    case failure
}
