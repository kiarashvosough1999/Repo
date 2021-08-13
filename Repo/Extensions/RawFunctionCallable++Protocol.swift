//
//  RawFunctionCallable++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/22/1400 AP.
//

import Foundation

internal protocol RawFunctionCallable: RawRepresentable {
    func callAsFunction() -> RawValue
}

internal extension RawFunctionCallable {
    func callAsFunction() -> RawValue {
        rawValue
    }
}
