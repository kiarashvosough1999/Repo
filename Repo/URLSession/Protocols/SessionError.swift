//
//  SessionError.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

enum SessionError: Error {
    case sessionDeinited
    case sessionIsNil(String)
    case optionCombinationIsNotAllowed
    case networkDisconnect
}
