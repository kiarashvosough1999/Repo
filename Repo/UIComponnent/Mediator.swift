//
//  Mediator.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import UIKit

@propertyWrapper
struct Targeted<T> where T: UIControl {
    
    var wrappedValue:T
    
    var projectedValue:T {
        wrappedValue
    }
    
    init<Target>(wrappedValue:T,on target: Target,_ events: KeyPath<Target,[UIControl.Event: Selector]>) {
        self.wrappedValue = wrappedValue
        register(on: target, events: events)
    }
    
    private func register<Target>(on target: Target, events: KeyPath<Target,[UIControl.Event: Selector]>){
        target[keyPath: events].forEach { (key: UIControl.Event, value: Selector) in
            wrappedValue.addTarget(target, action: value, for: key)
        }
    }
    
    init<Target>(wrappedValue:T,on target: Target,_ events: [UIControl.Event: KeyPath<Target,Selector>]) {
        self.wrappedValue = wrappedValue
        register(on: target, events: events)
    }
    
    private func register<Target>(on target: Target,events: [UIControl.Event: KeyPath<Target,Selector>]){
        events.forEach { (key: UIControl.Event, value: KeyPath<Target,Selector>) in
            wrappedValue.addTarget(target, action: target[keyPath: value], for: key)
        }
    }
    
    init<Target>(wrappedValue:T,on target: Target,_ events: [UIControl.Event: Selector]) {
        self.wrappedValue = wrappedValue
        register(on: target, events: events)
    }
    
    private func register<Target>(on target: Target,events: [UIControl.Event: Selector]){
        events.forEach { (key: UIControl.Event, value: Selector) in
            wrappedValue.addTarget(target, action: value, for: key)
        }
    }
}

extension UIControl.Event: Hashable {
    
}
