//
//  Operation+ViewExtension.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/23/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

extension Operation {
    
    var description: String {
        let texts = [Operation.remove: "remove-operation-dropdown-title".localized,
                     Operation.duplicate: "duplicate-operation-dropdown-title".localized,
                     Operation.calculateHashSum: "hashsum-operation-dropdown-title".localized]
        
        return texts[self]!
    }
    
    var confirmButtonText: String {
        let texts = [Operation.remove: "remove-operation-button-title".localized,
                     Operation.duplicate: "duplicate-operation-button-title".localized,
                     Operation.calculateHashSum: "hashsum-operation-button-title".localized]
        
        return texts[self]!
    }
}
