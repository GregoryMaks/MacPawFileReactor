//
//  ReactorViewModel.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/24/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class ReactorViewModel {
    
    let fileReactorService: FileReactorServiceProtocol
    
    var files = [URL]()
    var fileViewModels = [FileViewModel]()
    
    // TODO: maybe bindings are needed after all
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
    
    public var availableOperationsDidChange: (([Operation]) -> Void)?
    public var operationDidChange: ((Operation) -> Void)?
    public var filesDidChange: (([FileViewModel]) -> Void)?
    public var processingStatusDidChange: ((FileProcessingStatus) -> Void)?
    public var processingProgressDidChange: ((Double) -> Void)?
    public var userResultShouldShow: ((FileProcessingUserResult) -> Void)?
    
    public init(fileReactorService: FileReactorServiceProtocol) {
        self.fileReactorService = fileReactorService
    }
    
}

// MARK: - Methods

extension ReactorViewModel {
    
    public func initializeBindings() {
        availableOperationsDidChange?(availableOperations)
        operationDidChange?(currentOperation)
        filesDidChange?(fileViewModels)
        processingStatusDidChange?(processingStatus)
        processingProgressDidChange?(processingProgress)
    }
    
    public func appendFiles(byUrls urls: [URL]) {
        files.append(contentsOf: urls)
        fileViewModels.append(contentsOf: urls.map { fileViewModel(fromUrl: $0) })
        filesDidChange?(fileViewModels)
    }
    
    public func changeOperation(to operation: Operation) {
        currentOperation = operation
    }
    
    public func performCurrentOperation() {
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
            // TODO
            break
        case .calculateHashSum:
            // TODO
            break
        }
    }
    
}

// MARK: - Private methods

extension ReactorViewModel {
    
    private func fileViewModel(fromUrl url: URL) -> FileViewModel {
        let fileName = url.lastPathComponent
        
        var sizeString = "unknown"
        let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
        if let fileSize = (attrs?[.size] as? NSNumber)?.uint64Value {
            sizeString = fileSizeText(fromByteSize: fileSize)
        }
        
        return FileViewModel(filename: fileName, size: sizeString)
    }
    
    private func fileSizeText(fromByteSize byteSize: UInt64) -> String {
        let sizes = [ "bytes", "KB", "MB", "GB", "TB" ];
        var len = Double(byteSize);
        var order = 0;
        while len >= 1024 && order < sizes.count - 1 {
            order += 1;
            len = len / 1024.0;
        }
        
        return "\(String(format: "%.2f", len)) \(sizes[order])"
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
                        self.userResultShouldShow?(allSucceed ? .success : .partialSuccess)
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
