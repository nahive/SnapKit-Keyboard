//
//  KeyboardConstraints.swift
//  snapkitkeyboard
//
//  Created by Szymon Maślanka on 03/01/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit
import SnapKit

private var ckmSizeClass: UInt8 = 11
extension ConstraintMakerEditable {
    @discardableResult
    func auto(_ sizeClass: UIUserInterfaceSizeClass = .unspecified, keyboard shown: Bool? = nil, in view: UIView) -> ConstraintMakerEditable {
        switch sizeClass {
        case .regular:
            if let shown = shown {
                if shown { view.shownRegularConstraints.append(constraint) }
                else { view.hiddenRegularConstraints.append(constraint) }
            } else {
                view.regularConstraints.append(constraint)
            }
        case .compact:
            if let shown = shown {
                if shown { view.shownCompactConstraints.append(constraint) }
                else { view.hiddenCompactConstraints.append(constraint) }
            } else {
                view.compactConstraints.append(constraint)
            }
        case .unspecified:
            if let shown = shown {
                if shown { view.shownConstraints.append(constraint) }
                else { view.hiddenConstraints.append(constraint) }
            }
        }
        return self
    }
}

private var ckmShownRegular: UInt8 = 0
private var ckmShownCompact: UInt8 = 1
private var ckmHiddenRegular: UInt8 = 2
private var ckmHiddenCompact: UInt8 = 3
private var ckmRegular: UInt8 = 4
private var ckmCompact: UInt8 = 5
private var ckmShown: UInt8 = 6
private var ckmHidden: UInt8 = 7

extension UIView {
    fileprivate var shownRegularConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmShownRegular) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmShownRegular, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var shownCompactConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmShownCompact) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmShownCompact, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }

    fileprivate var hiddenRegularConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmHiddenRegular) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmHiddenRegular, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var hiddenCompactConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmHiddenCompact) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmHiddenCompact, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var regularConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmRegular) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmRegular, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var compactConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmCompact) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmCompact, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var shownConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmShown) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmShown, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    fileprivate var hiddenConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmHidden) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmHidden, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
    
    private dynamic func keyboardWillShow(notification: Notification){
        let duration = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let option = (notification as NSNotification).userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        hiddenConstraints.forEach { $0.deactivate() }
        shownConstraints.forEach { $0.activate() }
        
        switch traitCollection.verticalSizeClass {
        case .regular:
            hiddenRegularConstraints.forEach { $0.deactivate() }
            shownRegularConstraints.forEach { $0.activate() }
        case .compact:
            hiddenCompactConstraints.forEach { $0.deactivate() }
            shownCompactConstraints.forEach { $0.activate() }
        case .unspecified: break
        }
    
        UIView.animate(withDuration: duration, delay: 0,
                       options: UIViewAnimationOptions(rawValue: option.uintValue), animations: {
                        self.layoutIfNeeded()
        }, completion: nil)
    }
    
    private dynamic func keyboardWillHide(notification: Notification){
        let duration = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let option = (notification as NSNotification).userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        shownConstraints.forEach { $0.deactivate() }
        hiddenConstraints.forEach { $0.activate() }
        
        switch traitCollection.verticalSizeClass {
        case .regular:
            shownRegularConstraints.forEach { $0.deactivate() }
            hiddenRegularConstraints.forEach { $0.activate() }
        case .compact:
            shownCompactConstraints.forEach { $0.deactivate() }
            hiddenCompactConstraints.forEach { $0.activate() }
        case .unspecified: break
        }
        
        UIView.animate(withDuration: duration, delay: 0,
                       options: UIViewAnimationOptions(rawValue: option.uintValue), animations: {
                        self.layoutIfNeeded()
        }, completion: nil)
    }
    
    private dynamic func orientationDidChange(){
        if UIDevice.current.orientation.isLandscape {
            regularConstraints.forEach { $0.deactivate() }
            compactConstraints.forEach { $0.activate() }
        } else {
            compactConstraints.forEach { $0.deactivate() }
            regularConstraints.forEach { $0.activate() }
        }
    }
    
    func registerAutomaticKeyboardConstraints(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: .UIDeviceOrientationDidChange, object: nil)
        
    }
}
