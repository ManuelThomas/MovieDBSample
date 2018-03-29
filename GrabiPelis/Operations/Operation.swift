//
//  Operation.swift
//  GrabiPelis
//
//  Created by Manuel Thomas on 3/21/18.
//  Copyright © 2018 Grability. All rights reserved.
//

import Then

enum OperationType {
    case main
    case background
}

private let backgroundQueue = OperationQueue().then {
    $0.name = "mm.background.operation.queue"
}

class Operation: Foundation.Operation {
    
    convenience override required init() {
        self.init(type: .background)
    }
    
    fileprivate(set) var type: OperationType
    
    init(type: OperationType = .background) {
        self.type = type
        super.init()
    }
    
    func execute() {
        switch type {
        case .main:
            OperationQueue.main.addOperation(self)
            break
        case .background:
            backgroundQueue.addOperation(self)
        }
    }
}
