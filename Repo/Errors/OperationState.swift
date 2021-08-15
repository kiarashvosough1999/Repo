//
//  OperationState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

/// An enum indicating Operation's State
public enum OperationState {
    case ready
    case executing
    case finished
    case canceled
    case suspended
}
