//
//  SessionCancelOptions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

public enum SessionCancelOptions {
    public  typealias completionHandler = () -> Void
    case invalidateAndCancel
    case reset(completionHandler)
    case flush(completionHandler)
    case none
}
