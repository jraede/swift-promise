//
//  Promise.swift
//  Bummer
//
//  Created by Jason A Raede on 7/4/14.
//  Copyright (c) 2014 Bummerang. All rights reserved.
//

import Foundation

enum State { 
    case Pending
    case Fulfilled(Any)
    case Rejected(NSError)
}

class Promise<T> {
    var _successCallbacks: [((val:T) -> ())] = []
    var _failCallbacks: [((val:NSError) -> ())] = []
    
    var _finished: Bool = false
    var _resolved: Bool = false
    var _finalValue: Any = ""
    var _error:NSError
    
    
    init() {
        self._error = NSError()
        return;
    }
    
    class func defer() -> Promise {
        return Promise();
    }
    
    func then(callback: ((val:T) -> ())) -> Promise {
        self._successCallbacks.append(callback)
        if(self._finished) {
            if(self._resolved) {
                self._runSuccessCallbacks()
                self._reset()
            }
        }
        
        
        return self
    }
    

    
    func fail(callback: ((val:NSError) -> ())) -> Promise {
        self._failCallbacks.append(callback)
        if(self._finished) {
            if(self._resolved) {
                self._runFailCallbacks()
                self._reset()
            }
        }
        return self
    }
    
    func resolve(val:T) {
        if(self._finished) {
            return;
        }
        self._resolved = true
        self._finished = true
        self._finalValue = val
        self._runSuccessCallbacks()
        self._reset()
    }
    
    func reject(val:NSError) {
        if(self._finished) {
            return;
        }
        
        self._finished = true
        self._resolved = false
        self._error = val
        self._runFailCallbacks()
        self._reset()
    }
    
    func _reset() {
        self._successCallbacks.removeAll(keepCapacity: false)
        self._failCallbacks.removeAll(keepCapacity: false)
    }
    
    func _runSuccessCallbacks() {
        var val:T = self._finalValue as T
        for (index, callback) in enumerate(self._successCallbacks) {
            callback(val:val)
        }
        
    }
    
    func _runFailCallbacks() {
        for (index, callback) in enumerate(self._failCallbacks) {
            callback(val:self._error)
        }
    }
}
