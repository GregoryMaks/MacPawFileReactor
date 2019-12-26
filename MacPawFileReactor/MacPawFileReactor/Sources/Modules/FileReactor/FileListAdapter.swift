//
//  FileListAdapter.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/23/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Cocoa

class FileListAdapter: NSObject {
    
    private let NameCellIdentifier = "CellIdentifierName"
    private let SizeCellIdentifier = "CellIdentifierSize"
    
    weak var tableView: NSTableView!
    private var viewModels: [FileViewModel] = []
    
}

// MARK: - Public methods

extension FileListAdapter {
    
    func update(viewModels: [FileViewModel]) {
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
            identifier = NameCellIdentifier
        }
        else if tableColumn == tableView.tableColumns[1] {
            text = viewModel.size
            identifier = SizeCellIdentifier
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
