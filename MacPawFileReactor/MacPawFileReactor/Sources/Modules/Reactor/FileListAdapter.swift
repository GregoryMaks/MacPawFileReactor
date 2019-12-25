//
//  FileListAdapter.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/23/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Cocoa

class FileListAdapter: NSObject {
    
    public weak var tableView: NSTableView!
    var viewModels: [FileViewModel] = []
    
    override init() {
    }
    
}

// MARK: - Public methods

extension FileListAdapter {
    
    public func update(viewModels: [FileViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
}

extension FileListAdapter: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let viewModel = viewModels[row]
        var text: String = ""
        var identifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            text = viewModel.filename
            identifier = "CellIdentifierName"
        }
        else if tableColumn == tableView.tableColumns[1] {
            text = viewModel.size
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
