//
//  StateFullOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/22/1400 AP.
//

import Foundation

/**

 `SafeOperation` subclassed from   `Operation`.
 
 It offers new features which the operation itself does not support or could be so tricky to use
 
 It provide `thread safe` operation flags `setter` and `getter` an dhold the flags on its own local variable
 
 All the flags are synchronized within a muetx lock of type `NSLock`,
 
 This can be handy when several threads trying to change the operation's flags at the same time
 
 If you want to access the `OperationQueue` which this operation was added to it
 
 No worry, it has and weak refrenence to its parent `OperationQueue` (not thread safe)
 
 Use this refrence carefully, any misuse will result in crash or unexpected behavior.
 
 This class conforms to `IdentifiableOperation` protocol, which can be identified with unique identifier,
 
 This can be useful when adding or removing dependencies.
 
 */
public class SafeOperation: Operation {
    
    /// Any changes to operation flags will be stored on these variables
    lazy private var _executing: Bool = false
    
    lazy private var _finished: Bool = false
    
    lazy private var _canceled: Bool = false
    
    lazy private var _suspended: Bool = false
    
    /// `Thread Safe Readable and Settable` Variables Indicating Operation Flags
    
    /**
     
     `All these properties are observed (as key value) and any chnages should be informed`
     
     If you have the intent to override this variable, take care of two things:
     - Synchronize the setter and getter.
     - Informs the observed object that the value of a given property is about to change.
     
     */
    
    public override internal(set) var isExecuting: Bool {
        get {
            return lock.synchronize { _executing }
        }
        set {
            willChangeValue(forKey: #keyPath(Operation.isExecuting))
            lock.synchronize { _executing = newValue }
            didChangeValue(forKey: #keyPath(Operation.isExecuting))
        }
    }
    public override internal(set) var isFinished: Bool {
        get {
            return lock.synchronize { _finished }
        }
        set {
            willChangeValue(forKey: #keyPath(Operation.isFinished))
            lock.synchronize { _finished = newValue }
            didChangeValue(forKey: #keyPath(Operation.isFinished))
        }
    }
    
    public override internal(set) var isCancelled: Bool {
        get {
            return lock.synchronize { _canceled }
        }
        set {
            willChangeValue(forKey: #keyPath(Operation.isCancelled))
            lock.synchronize { _canceled = newValue }
            didChangeValue(forKey: #keyPath(Operation.isCancelled))
        }
    }
    
    /// Overridable property indicating whether the operation is `async` or not
    public override var isAsynchronous: Bool { return true }
    
    /// a `mutex lock` to `synchronize` some properties between threads
    private let lock: NSLock
    
    /// the `Operation Queue` which this operation work with
    internal private(set) weak var operationQueue:OperationQueue?
    
    // MARK: - init
    internal init(operationQueue: OperationQueue?) {
        self.lock = NSLock()
        self.operationQueue = operationQueue
        super.init()
    }
    
    public override func start() {
        if _canceled {
            isFinished = true
            isExecuting = false
            return
        }
        main()
    }
}

