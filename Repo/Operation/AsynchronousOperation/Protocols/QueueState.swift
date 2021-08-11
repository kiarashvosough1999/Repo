//
//  QueueState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/20/1400 AP.
//

import Foundation

public struct QueueState {
    
    internal var enqueued: Bool
    internal var enqueuedAfter: TimeInterval = 0.0
    
    internal var willEnqueue: Bool { !enqueued && enqueuedAfter > 0.0 }
}
