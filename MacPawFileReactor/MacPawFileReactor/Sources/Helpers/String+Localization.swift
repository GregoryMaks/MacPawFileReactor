//
//  String+Localization.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/26/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(withComment comment: String) -> String {
        NSLocalizedString(self, comment: comment)
    }
    
}
