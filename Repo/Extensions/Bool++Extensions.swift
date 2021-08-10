//
//  Bool++Extensions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

extension Bool {
    
    /// Execute some closure if optionsl is `True`
    func accept(true: () throws -> Void) rethrows {
        if self { try `true`() }
    }
    
    /// Execute some closure if optionsl is `True`
    func reject(false: () throws -> Void) rethrows {
        if !self { try `false`() }
    }
    
}
