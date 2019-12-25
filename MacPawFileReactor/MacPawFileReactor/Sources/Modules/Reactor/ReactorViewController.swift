//
//  ReactorViewController.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/21/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Cocoa

class ReactorViewController: NSViewController {

    let tableViewAdapter = FileListAdapter()
    
    @IBOutlet weak var operationPopupButton: NSPopUpButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var progressLabel: NSTextField!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var performOperationButton: NSButton!
    
    var viewModel: ReactorViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewAdapter.tableView = tableView
        tableView.dataSource = tableViewAdapter
        tableView.delegate = tableViewAdapter
        
        // TODO: maybe move out to appCoordinator?
        let fileReactorService = FileReactorService()
        bind(viewModel: ReactorViewModel(fileReactorService: fileReactorService))
    }

//    override var representedObject: Any? {
//        didSet {
//        }
//    }
    
    public func bind(viewModel: ReactorViewModel) {
        self.viewModel = viewModel
        
        viewModel.availableOperationsDidChange = { [weak self] operations in
            guard let `self` = self else { return }
            self.operationPopupButton.removeAllItems()
            self.operationPopupButton.addItems(withTitles: operations.map { $0.description })
        }
        
        viewModel.operationDidChange = { [weak self] operation in
            guard let `self` = self else { return }
            self.performOperationButton.title = operation.confirmButtonText
        }
        
        viewModel.filesDidChange = { [weak self] files in
            guard let `self` = self else { return }
            self.tableViewAdapter.update(viewModels: files)
        }
        
        viewModel.processingStatusDidChange = { [weak self] status in
            guard let `self` = self else { return }
            let hideProgressElements = (status == .idle)
            self.progressIndicator.isHidden = hideProgressElements
            self.progressLabel.isHidden = hideProgressElements
        }
        
        viewModel.processingProgressDidChange = { [weak self] progress in
            guard let `self` = self else { return }
            self.progressIndicator.doubleValue = progress
            self.progressLabel.stringValue = String(format: "%.0f litres of grog left... ", (1.0 - progress) * 100)
        }
        
        viewModel.userResultShouldShow = { [weak self] userResult in
            guard let `self` = self else { return }
            self.show(userMessage: userResult.message, withDescription: userResult.informativeDescription)
        }
        
        viewModel.initializeBindings()
    }
    
    // MARK: - Actions
    
    @IBAction func openDocument(_ sender: Any) {
        openFileSelectionPanel()
    }
    
    @IBAction func performOperation(_ sender: NSButton) {
        viewModel.performCurrentOperation()
    }
    
    @IBAction func updateOperationAction(_ sender: NSPopUpButton) {
        let operation = Operation(rawValue: operationPopupButton.indexOfSelectedItem)!
        viewModel.changeOperation(to: operation)
    }
    
}

// MARK: - Private methods

extension ReactorViewController {
        
    func openFileSelectionPanel() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.canDownloadUbiquitousContents = false
        openPanel.begin { (result) -> Void in
            if result == .OK {
                self.viewModel.appendFiles(byUrls: openPanel.urls)
            }
        }
    }
    
    func show(userMessage: String, withDescription description: String) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = userMessage
        alert.informativeText = description
        alert.addButton(withTitle: "Aye")
        alert.runModal()
    }
    
}
