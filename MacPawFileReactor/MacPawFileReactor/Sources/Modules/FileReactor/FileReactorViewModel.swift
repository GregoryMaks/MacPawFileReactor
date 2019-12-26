//
//  ReactorViewModel.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/24/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class FileReactorViewModel {
    
    let fileReactorService: FileReactorServiceProtocol
    
    var files = [URL]()
    var fileViewModels = [FileViewModel]()
    
    var availableOperations = Operation.allCases
    var currentOperation = Operation.remove {
        didSet { operationDidChange?(currentOperation) }
    }
    var processingStatus = FileProcessingStatus.idle {
        didSet { processingStatusDidChange?(processingStatus) }
    }
    var processingProgress: Double = 0 {
        didSet { processingProgressDidChange?(processingProgress) }
    }
    
    // MARK: - Bindings
    
    var availableOperationsDidChange: (([Operation]) -> Void)?
    var operationDidChange: ((Operation) -> Void)?
    var filesDidChange: (([FileViewModel]) -> Void)?
    var processingStatusDidChange: ((FileProcessingStatus) -> Void)?
    var processingProgressDidChange: ((Double) -> Void)?
    var userResultShouldShow: ((FileProcessingResult) -> Void)?
    
    init(fileReactorService: FileReactorServiceProtocol) {
        self.fileReactorService = fileReactorService
    }
    
}

// MARK: - Methods

extension FileReactorViewModel {
    
    func initializeBindings() {
        availableOperationsDidChange?(availableOperations)
        operationDidChange?(currentOperation)
        filesDidChange?(fileViewModels)
        processingStatusDidChange?(processingStatus)
        processingProgressDidChange?(processingProgress)
    }
    
    func appendFiles(byUrls urls: [URL]) {
        files.append(contentsOf: urls)
        fileViewModels.append(contentsOf: urls.map { fileViewModel(fromUrl: $0) })
        filesDidChange?(fileViewModels)
    }
    
    func changeOperation(to operation: Operation) {
        currentOperation = operation
    }
    
    func performCurrentOperation() {
        guard files.count > 0 else {
            userResultShouldShow?(.noItemsToProcess)
            return
        }
        
        processingStatus = .running
        processingProgress = 0
        
        switch currentOperation {
        case .remove:
            removeSelectedFiles()
        case .duplicate:
            duplicateSelectedFiles()
        case .calculateHashSum:
            calculateHashOfSelectedFiles()
        }
    }
    
}

// MARK: - Private methods

extension FileReactorViewModel {
    
    private func fileViewModel(fromUrl url: URL) -> FileViewModel {
        let fileName = url.lastPathComponent
        
        var sizeString = "file-size-unknown".localized
        let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
        if let fileSize = (attrs?[.size] as? NSNumber)?.uint64Value {
            sizeString = String.readableFileSize(fromByteSize: fileSize)
        }
        
        return FileViewModel(filename: fileName, size: sizeString)
    }
    
    private func removeSuccessfullyProcessedFiles(usingResults results:[Bool]) {
        var newFiles = [URL]()
        for i in 0..<files.count {
            if results[i] == false {
                newFiles.append(files[i])
            }
        }
        files = newFiles
        fileViewModels = files.map { fileViewModel(fromUrl: $0) }
        filesDidChange?(fileViewModels)
    }
    
    private func removeSelectedFiles() {
        let progressTracker = fileReactorService.removeFiles(atURLs: files) { [weak self] result in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.processingStatus = .idle
                result.analyze(
                    ifSuccess: { separateFilesStatus -> Void in
                        let allSucceed = separateFilesStatus.allSatisfy { $0 }
                        self.removeSuccessfullyProcessedFiles(usingResults: separateFilesStatus)
                        self.userResultShouldShow?(allSucceed ? .success(nil) : .partialSuccess)
                    },
                    ifFailure: { error in
                        self.userResultShouldShow?(.failure)
                    }
                )
            }
        }
        
        progressTracker.progressDidChange = { [weak self] fractionCompleted in
            self?.processingProgress = fractionCompleted
        }
    }
    
    private func duplicateSelectedFiles() {
        let progressTracker = fileReactorService.duplicateFiles(atURLs: files) { [weak self] result in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.processingStatus = .idle
                result.analyze(
                    ifSuccess: { separateFilesStatus -> Void in
                        let allSucceed = separateFilesStatus.allSatisfy { $0 }
                        self.removeSuccessfullyProcessedFiles(usingResults: separateFilesStatus)
                        self.userResultShouldShow?(allSucceed ? .success(nil) : .partialSuccess)
                    },
                    ifFailure: { error in
                        self.userResultShouldShow?(.failure)
                    }
                )
            }
        }
        
        progressTracker.progressDidChange = { [weak self] fractionCompleted in
            self?.processingProgress = fractionCompleted
        }
    }
    
    private func calculateHashOfSelectedFiles() {
        let progressTracker = fileReactorService.countHashSumOfFiles(atURLs: files) { [weak self] result in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.processingStatus = .idle
                result.analyze(
                    ifSuccess: { separateFilesHashData -> Void in
                        let allSucceed = separateFilesHashData.allSatisfy { $0.count > 0 }
                        let hashPreview = separateFilesHashData
                            .filter { $0.count > 0 }
                            .prefix(10)
                            .reduce("hash-sum-alert-header".localized) { "\($0)\n\($1.hashString)" }
                        self.userResultShouldShow?(allSucceed ? .success(hashPreview) : .partialSuccess)
                    },
                    ifFailure: { error in
                        self.userResultShouldShow?(.failure)
                    }
                )
            }
        }
        
        progressTracker.progressDidChange = { [weak self] fractionCompleted in
            self?.processingProgress = fractionCompleted
        }
    }
    
}
