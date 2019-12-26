//
//  String+FileSizeFormatter.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/26/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

extension String {

    static func readableFileSize(fromByteSize byteSize: UInt64) -> String {
        let sizes = [
            "file-size-bytes".localized,
            "file-size-KB".localized,
            "file-size-MB".localized,
            "file-size-GB".localized,
            "file-size-TB".localized
        ];
        var len = Double(byteSize);
        var order = 0;
        while len >= 1024 && order < sizes.count - 1 {
            order += 1;
            len = len / 1024.0;
        }
        
        return "\(String(format: "%.2f", len)) \(sizes[order])"
    }

}
