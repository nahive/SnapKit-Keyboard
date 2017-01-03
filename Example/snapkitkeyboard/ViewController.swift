//
//  ViewController.swift
//  snapkitkeyboard
//
//  Created by Szymon Maślanka on 03/01/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let topViewReplacement: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let topMiddleView: UITextField = {
        let view = UITextField()
        view.backgroundColor = .green
        return view
    }()
    
    let bottomMiddleView: UITextField = {
        let view = UITextField()
        view.backgroundColor = .gray
        return view
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup(){
        setupSubviews()
        setupObservers()
    }
    
    private func setupSubviews(){
        view.addSubview(topView)
        view.addSubview(topViewReplacement)
        view.addSubview(topMiddleView)
        view.addSubview(bottomMiddleView)
        view.addSubview(bottomView)
    }
    
    private func setupObservers(){
        view.registerAutomaticKeyboardConstraints()
    }
    
    private func setupRegularConstraints(){
        topView.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top).keyboard(false, in: view)
            make.height.equalTo(100)
        }
        
        topView.snp.prepareConstraints { (make) in
            make.bottom.equalTo(view.snp.top).keyboard(true, in: view)
        }
        
        topViewReplacement.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.top).keyboard(false, in: view)
            make.height.equalTo(100)
        }
        
        topViewReplacement.snp.prepareConstraints { (make) in
            make.top.equalTo(view.snp.top).keyboard(true, in: view)
        }
        
        topMiddleView.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(44)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-44).keyboard(false, in: view)
        }
        
        topMiddleView.snp.prepareConstraints { (make) in
            make.centerY.equalTo(view.snp.centerY).offset(-144).keyboard(true, in: view)
        }
        
        bottomMiddleView.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(44)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(topMiddleView.snp.bottom).offset(44)
        }
        
        bottomView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-44).keyboard(false, in: view)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(55)
        }
        
        bottomView.snp.prepareConstraints { (make) in
            make.top.equalTo(bottomMiddleView.snp.bottom).offset(20).keyboard(true, in: view)
        }
    }
    
    private func setupCompactConstraints(){
        topView.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(view.snp.top).keyboard(false, in: view)
            make.height.equalTo(100)
        }
        
        topView.snp.prepareConstraints { (make) in
            make.bottom.equalTo(view.snp.top).keyboard(true, in: view)
        }
        
        topViewReplacement.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.top).keyboard(false, in: view)
            make.height.equalTo(100)
        }
        
        topViewReplacement.snp.prepareConstraints { (make) in
            make.top.equalTo(view.snp.top).keyboard(true, in: view)
        }
        
        topMiddleView.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.centerX).offset(-20).keyboard(false, in: view)
            make.height.equalTo(44)
            make.centerY.equalTo(view.snp.centerY).keyboard(false, in: view)
        }
        
        topMiddleView.snp.prepareConstraints { (make) in
            make.right.equalTo(view.snp.centerX).offset(-64).keyboard(true, in: view)
            make.centerY.equalTo(view.snp.centerY).offset(-44).keyboard(true, in: view)
        }
        
        bottomMiddleView.snp.remakeConstraints { (make) in
            make.left.equalTo(view.snp.centerX).offset(20).keyboard(false, in: view)
            make.right.equalTo(view.snp.right).offset(-20).keyboard(false, in: view)
            make.height.equalTo(44)
            make.centerY.equalTo(topMiddleView.snp.centerY)
        }
        
        bottomMiddleView.snp.prepareConstraints { (make) in
            make.left.equalTo(topMiddleView.snp.right).offset(16).keyboard(true, in: view)
        }
        
        bottomView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-44).keyboard(false, in: view)
            make.centerX.equalTo(view.snp.centerX).keyboard(false, in: view)
            make.width.equalTo(100)
            make.height.equalTo(55)
        }
        
        bottomView.snp.prepareConstraints { (make) in
            make.centerY.equalTo(bottomMiddleView.snp.centerY).keyboard(true, in: view)
            make.left.equalTo(bottomMiddleView.snp.right).offset(8).keyboard(true, in: view)
            make.right.equalTo(view.snp.right).offset(-8).keyboard(true, in: view)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection != previousTraitCollection else { return }
        switch traitCollection.verticalSizeClass {
        case .regular: setupRegularConstraints()
        case .compact: setupCompactConstraints()
        case .unspecified: print("unspecified vertical size class")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

