//
//  FileProcessingUserResult.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

enum FileProcessingUserResult {
    case noItemsToProcess
    case success
    case partialSuccess
    case failure
}

extension FileProcessingUserResult {
    
    var message: String {
        switch self {
        case .noItemsToProcess: return "Aye free rum? For us, captain?"
        case .success: return "Yo ho ho! We did it, captain!"
        case .partialSuccess: return "Mixed news from our lad captain. We'll make him a shark bait next time!"
        case .failure: return "Son of a Biscuit Eater! We failed, captain."
        }
    }
    
    var informativeDescription: String {
        switch self {
        case .noItemsToProcess: return "Please add some files to process"
        case .success: return "All files were processed"
        case .partialSuccess: return "Some files were not processed correctly"
        case .failure: return "File processing failed"
        }
    }
    
}
