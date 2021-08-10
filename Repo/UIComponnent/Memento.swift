//
//  Memento.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

protocol SnapShotMaker {
    associatedtype SnapShot
    func makeSnapShot() -> SnapShot
}

protocol StatedObject {
    associatedtype State
    var state: State { get }
    func setState(from last:State?) -> Self
}

extension Array where Element: StatedObject {
    
    func forEach(_ callback: (Element) -> ()) {
        for index in 0..<self.count {
            if index - 1 < 0 { callback(self[index])}
            else {
                callback(self[index].setState(from: self[index-1].state))
            }
        }
    }
}

extension Array where Element: SnapShotMaker {
    
    func concurrentForEach(_ callback: (Element) -> ()) {
        DispatchQueue.concurrentPerform(iterations: self.count) { (index) in
            callback(self[index])
        }
    }
    
    func concurrentForEach(_ callback: (Element.SnapShot?,Element) -> ()) {
        DispatchQueue.concurrentPerform(iterations: self.count) { (index) in
            if index - 1 < 0 { callback(nil, self[index])}
            else { callback(self[index-1].makeSnapShot(), self[index])}
        }
    }
    
    func forEach(_ callback: (Element.SnapShot?,Element) -> ()) {
        for index in 0..<self.count {
            if index - 1 < 0 { callback(nil, self[index])}
            else { callback(self[index-1].makeSnapShot(), self[index])}
        }
    }
    
    func forEach(_ callback: (Element.SnapShot,Element) -> ()) {
        for index in 0..<self.count {
            if index - 1 < 0 { callback(self[index].makeSnapShot(), self[index])}
            else { callback(self[index-1].makeSnapShot(), self[index])}
        }
    }
}
