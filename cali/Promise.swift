//
//  Promise.swift
//  cali
//
//  Created by will3 on 14/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

enum NoError : Error { }

enum PromiseState {
    case pending
    case success
    case error
}

/// Bare bare bones promise implementation
class Promise<ResultType, ErrorType: Error> {
    typealias ResultBlock = (ResultType) -> Void
    typealias CatchBlock = (ErrorType) -> Void
    
    var thenBlock: ResultBlock?
    var catchBlock: CatchBlock?
    var state: PromiseState = .pending
    var value: ResultType?
    var err: ErrorType?
    
    init() { }
    
    init(value: ResultType) {
        self.value = value
        self.state = .success
    }
    
    func resolve(value: ResultType) {
        state = .success
        self.value = value
        
        self.thenBlock?(value)
    }
    
    func reject(err: ErrorType) {
        state = .error
        self.err = err
        
        self.catchBlock?(err)
    }
    
    @discardableResult
    func then(block: @escaping ResultBlock) -> Self {
        self.thenBlock = block
        
        if state == .success {
            if let value = self.value {
                block(value)
            }
        }
        
        return self
    }
    
    func `catch`(block: @escaping CatchBlock) {
        self.catchBlock = block
        
        if state == .error {
            if let err = self.err {
                block(err)
            }
        }
    }
}
