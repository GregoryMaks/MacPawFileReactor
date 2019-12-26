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
        
        progressIndicator.minValue = 0
        progressIndicator.maxValue = 1
        
        // TODO: maybe move out to appCoordinator?
        let fileReactorService = FileReactorService()
        bind(viewModel: ReactorViewModel(fileReactorService: fileReactorService))
    }
    
    public func bind(viewModel: ReactorViewModel) {
        self.viewModel = viewModel
        
        viewModel.availableOperationsDidChange = { [weak self] operations in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.operationPopupButton.removeAllItems()
                self.operationPopupButton.addItems(withTitles: operations.map { $0.description })
            }
        }
        
        viewModel.operationDidChange = { [weak self] operation in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.performOperationButton.title = operation.confirmButtonText
            }
        }
        
        viewModel.filesDidChange = { [weak self] files in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.tableViewAdapter.update(viewModels: files)
            }
        }
        
        viewModel.processingStatusDidChange = { [weak self] status in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                let controlsEnabled = (status == .idle)
                
                self.operationPopupButton.isEnabled = controlsEnabled
                self.performOperationButton.isEnabled = controlsEnabled
            }
        }
        
        viewModel.processingProgressDidChange = { [weak self] progress in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.progressIndicator.doubleValue = progress
                if (progress == 0) {
                    self.progressLabel.stringValue = "Hold ya paddles, lads"
                }
                else if (progress == 1) {
                    self.progressLabel.stringValue = "A fifteen men on a dead man's chest, yohoho and no rum left"
                }
                else {
                    self.progressLabel.stringValue = String(format: "%.0f bottles of rum left... ", (1.0 - progress) * 100)
                }
                
            }
        }
        
        viewModel.userResultShouldShow = { [weak self] userResult in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.show(userMessage: userResult.message, withDescription: userResult.informativeDescription)
            }
        }
        
        viewModel.initializeBindings()
    }
    
    // MARK: - Actions
    
    @IBAction func openDocument(_ sender: Any) {
        guard self.viewModel.processingStatus == .idle else { return }
        openFileSelectionPanel()
    }
    
    @IBAction func performOperation(_ sender: NSButton) {
        guard self.viewModel.processingStatus == .idle else { return }
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
