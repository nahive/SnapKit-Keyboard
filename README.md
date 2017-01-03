# SnapKit-Keyboard
Handling keyboard appearing/disappearing in SnapKit.

### How to use it?
In ```viewDidLoad``` or other initializing place in code call ```view.registerAutomaticKeyboardConstraints()```.

```swift
override func viewDidLoad(){
    view.registerAutomaticKeyboardConstraints()
}
```

Then while adding constraints add ```.keyboard(false, in: view)``` to constraints in ```make``` or ```remake``` to deactivate them automatically when keyboard appears.

```swift
topView.snp.makeConstraints { (make) in
   make.left.equalTo(view.snp.left)
   make.right.equalTo(view.snp.right)
   make.top.equalTo(view.snp.top).keyboard(false, in: view)
   make.height.equalTo(100)
}        
```

As for constraints you want to keep/install when keyboard appears call ```.keyboard(true, in: view)``` on them in ```.snp.prepareConstraints```. 

```swift
topView.snp.prepareConstraints { (make) in
   make.bottom.equalTo(view.snp.top).keyboard(true, in: view)
}
```

If your view is launching with keyboard already shown - you should switch ```.makeConstraints``` with ```.prepareConstraints``` so that ```.makeConstraints``` constains code for keyboard shown constraints and ```.prepareConstraints``` should in that case contain code for keyboard hidden.
