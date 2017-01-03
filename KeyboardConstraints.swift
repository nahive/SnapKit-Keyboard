//
//  KeyboardConstraints.swift
//  snapkitkeyboard
//
//  Created by Szymon Maślanka on 03/01/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit
import SnapKit

extension ConstraintMakerEditable {
    @discardableResult
    func keyboard(_ shown: Bool, in view: UIView) -> ConstraintMakerEditable {
        switch view.traitCollection.verticalSizeClass {
        case .regular:
            if shown { view.shownRegularConstraints.append(constraint) }
            else { view.hiddenRegularConstraints.append(constraint) }
        case .compact:
            if shown { view.shownCompactConstraints.append(constraint) }
            else { view.hiddenCompactConstraints.append(constraint) }
        case .unspecified: break
        }
        return self
    }
}

private var ckmShownRegular: UInt8 = 0
private var ckmShownCompact: UInt8 = 1
private var ckmHiddenRegular: UInt8 = 2
private var ckmHiddenCompact: UInt8 = 3
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
    
    private dynamic func keyboardWillShow(notification: Notification){
        let duration = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let option = (notification as NSNotification).userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
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
    
    func registerAutomaticKeyboardConstraints(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
}
