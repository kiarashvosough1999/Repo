//
//  CommandExecutable.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

protocol CommandExecutable:AnyObject {
    var commandHistory: CommandHistory { get }
}
