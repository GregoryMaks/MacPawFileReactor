//
//  ViewController.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/21/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let tableViewAdapter = FileListAdapter()
    
    @IBOutlet weak var operationPopupButton: NSPopUpButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var progressLabel: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var performOperationButton: NSButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewAdapter.tableView = tableView
        tableView.dataSource = tableViewAdapter
        tableView.delegate = tableViewAdapter
        
        // TODO: remove mock data
        let fileRecords = [
            FileRecord(name: "First file.png", size: 620),
            FileRecord(name: "Second file.png", size: 20000),
            FileRecord(name: "Third file.png", size: 6000000)
        ]
        tableViewAdapter.update(records: fileRecords)
        
        setupOperationList()
        updateOperation(with: .remove)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: - Actions
    
    @IBAction func performOperation(_ sender: NSButton) {
        
    }
    
    @IBAction func updateOperationAction(_ sender: NSPopUpButton) {
        let operation = Operation(rawValue: operationPopupButton.indexOfSelectedItem)!
        updateOperation(with: operation)
    }
    
    // MARK: - Private methods
    
    func setupOperationList() {
        operationPopupButton.removeAllItems()
        operationPopupButton.addItems(withTitles: Operation.allCases.map { $0.description })
    }
    
    func updateOperation(with operation: Operation) {
        performOperationButton.title = operation.confirmButtonText
    }
    
}
