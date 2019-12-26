//
//  FileProcessingResult+ViewExtension.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/26/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

extension FileProcessingResult {
    
    var message: String {
        switch self {
        case .noItemsToProcess: return "alert-title-no-items-to-process".localized
        case .success: return "alert-title-success".localized
        case .partialSuccess: return "alert-title-partial-success".localized
        case .failure: return "alert-title-failure".localized
        }
    }
    
    var informativeDescription: String {
        switch self {
        case .noItemsToProcess: return "alert-informative-no-items-to-process".localized
        case .success(let customResult): return customResult ?? "alert-informative-success".localized
        case .partialSuccess: return "alert-informative-partial-success".localized
        case .failure: return "alert-informative-failure".localized
        }
    }
    
}
