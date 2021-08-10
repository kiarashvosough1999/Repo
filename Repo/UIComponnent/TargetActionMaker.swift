//
//  TargetActionMaker.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import UIKit

//class TargetDispacher<T: UIControl> where T:BaseComponnent {
//
//    weak var componnent: BaseComponnent?
//
//    init(_ sender: T, events: [UIControl.Event]) {
//        self.componnent = sender
//        events.foreach
//        events.forEach { event in
//            addActions(sender, target: self, event: event)
//        }
//    }
//
//    fileprivate func addActions(_ sender: T, target: Any?, event: UIControl.Event) {
//        switch event {
//            case .touchDown:
//                sender.addTarget(target, action: #selector(touchDownEvent), for: .touchDown)
//            case .touchDownRepeat:
//                sender.addTarget(target, action: #selector(touchDownRepeatEvent), for: .touchDownRepeat)
//            case .touchDragInside:
//                sender.addTarget(target, action: #selector(touchDragInsideEvent), for: .touchDragInside)
//            case .touchDragOutside:
//                sender.addTarget(target, action: #selector(touchDragOutsideEvent), for: .touchDragOutside)
//            case .touchDragEnter:
//                sender.addTarget(target, action: #selector(touchDragEnterEvent), for: .touchDragEnter)
//            case .touchDragExit:
//                sender.addTarget(target, action: #selector(touchDragExitEvent), for: .touchDragExit)
//            case .touchUpInside:
//                sender.addTarget(target, action: #selector(touchUpInsideEvent), for: .touchUpInside)
//            case .touchUpOutside:
//                sender.addTarget(target, action: #selector(touchUpOutsideEvent), for: .touchUpOutside)
//            case .touchCancel:
//                sender.addTarget(target, action: #selector(touchCancelEvent), for: .touchCancel)
//            case .valueChanged:
//                sender.addTarget(target, action: #selector(valueChangedEvent), for: .valueChanged)
//            case .primaryActionTriggered:
//                sender.addTarget(target, action: #selector(primaryActionTriggeredEvent), for: .primaryActionTriggered)
//            case .editingDidBegin:
//                sender.addTarget(target, action: #selector(editingDidBeginEvent), for: .editingDidBegin)
//            case .editingChanged:
//                sender.addTarget(target, action: #selector(editingChangedEvent), for: .editingChanged)
//            case .editingDidEnd:
//                sender.addTarget(target, action: #selector(editingDidEndEvent), for: .editingDidEnd)
//            case .editingDidEndOnExit:
//                sender.addTarget(target, action: #selector(editingDidEndOnExitEvent), for: .editingDidEndOnExit)
//            case .allTouchEvents:
//                sender.addTarget(target, action: #selector(allTouchEvents), for: .allTouchEvents)
//            case .allEditingEvents:
//                sender.addTarget(target, action: #selector(allEditingEvents), for: .allEditingEvents)
//            case .applicationReserved:
//                sender.addTarget(target, action: #selector(applicationReservedEvent), for: .applicationReserved)
//            case .systemReserved:
//                sender.addTarget(target, action: #selector(systemReservedEvent), for: .systemReserved)
//            case .allEvents:
//                sender.addTarget(target, action: #selector(allEvents), for: .allEvents)
//            default:
//                fatalError()
//        }
//    }
//
//
//    @objc fileprivate func touchDownEvent() {
//        componnent?.Triggered(with: .touchDown)
//    }
//    @objc fileprivate func touchDownRepeatEvent() {
//        componnent?.Triggered(with: .touchDownRepeat)
//    }
//    @objc fileprivate func touchDragInsideEvent() {
//        componnent?.Triggered(with: .touchDragInside)
//    }
//    @objc fileprivate func touchDragOutsideEvent() {
//        componnent?.Triggered(with: .touchDragOutside)
//    }
//
//    @objc fileprivate func touchDragEnterEvent() {
//        componnent?.Triggered(with: .touchDragEnter)
//    }
//
//    @objc fileprivate func touchDragExitEvent() {
//        componnent?.Triggered(with: .touchDragExit)
//    }
//
//    @objc fileprivate func touchUpOutsideEvent() {
//        componnent?.Triggered(with: .touchUpOutside)
//    }
//
//    @objc fileprivate func touchUpInsideEvent() {
//        componnent?.Triggered(with: .touchUpInside)
//    }
//
//    @objc fileprivate func touchCancelEvent() {
//        componnent?.Triggered(with: .touchCancel)
//    }
//
//    @objc fileprivate func valueChangedEvent() {
//        componnent?.Triggered(with: .valueChanged)
//    }
//
//    @objc fileprivate func primaryActionTriggeredEvent() {
//        componnent?.Triggered(with: .primaryActionTriggered)
//    }
//
//    @objc fileprivate func editingDidBeginEvent() {
//        componnent?.Triggered(with: .editingDidBegin)
//    }
//
//    @objc fileprivate func editingChangedEvent() {
//        componnent?.Triggered(with: .editingChanged)
//    }
//
//    @objc fileprivate func editingDidEndEvent() {
//        componnent?.Triggered(with: .editingDidEnd)
//    }
//
//    @objc fileprivate func editingDidEndOnExitEvent() {
//        componnent?.Triggered(with: .editingDidEndOnExit)
//    }
//
//    @objc fileprivate func allTouchEvents() {
//        componnent?.Triggered(with: .allTouchEvents)
//    }
//
//    @objc fileprivate func allEditingEvents() {
//        componnent?.Triggered(with: .allEditingEvents)
//    }
//
//    @objc fileprivate func applicationReservedEvent() {
//        componnent?.Triggered(with: .applicationReserved)
//    }
//
//    @objc fileprivate func systemReservedEvent() {
//        componnent?.Triggered(with: .systemReserved)
//    }
//
//    @objc fileprivate func allEvents() {
//        componnent?.Triggered(with: .allEvents)
//    }
//
//
//}
