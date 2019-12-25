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
        let texts = [Operation.remove: "throw them overboard, lads! (delete)",
                     Operation.duplicate: "make me twice as much, goddamit! (duplicate)",
                     Operation.calculateHashSum: "count the doubloons, hearties! (count hash sum)"]
        
        return texts[self]!
    }
    
    var confirmButtonText: String {
        let texts = [Operation.remove: "Throw them overboard!",
                     Operation.duplicate: "Twice as much!",
                     Operation.calculateHashSum: "Count 'em up!"]
        
        return texts[self]!
    }
}
