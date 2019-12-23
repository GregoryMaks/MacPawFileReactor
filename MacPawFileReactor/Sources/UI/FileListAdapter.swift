//
//  FileListAdapter.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/23/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Cocoa

struct FileRecord {
    var name: String
    var size: UInt64
}

class FileListAdapter: NSObject {
    public weak var tableView: NSTableView!
    var fileRecords: [FileRecord] = []
    
    override init() {
    }
    
    public func update(records: [FileRecord]) {
        fileRecords = records
        tableView.reloadData()
    }
    
}

extension FileListAdapter: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return fileRecords.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let record = fileRecords[row]
        var text: String = ""
        var identifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            text = record.name
            identifier = "CellIdentifierName"
        }
        else if tableColumn == tableView.tableColumns[1] {
            text = record.size.description
            identifier = "CellIdentifierSize"
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: nil)
            as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
    
}

extension FileListAdapter: NSTableViewDelegate {
}
