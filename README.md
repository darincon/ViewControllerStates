# ViewControllerStates

A simple project that shows how implementing states makes it easier to manage and update UI animations by defining each element's behavior for a given state.

## Description
The project has a simple login screen with 4 different states:

```swift
enum LoginState {
	case initial, waiting, invalidEmail, ready
}
```

1. **Initial**: When the view controller has been loaded on the screen.
2. **Waiting**: Waiting for the user to type in email and password.
3. **Invalid email**: The entered email is not valid. An error message is displayed.
4. **Ready**: The data has been successfully validated and the user is now allowed to attempt to log in.

![alt tag](/demo.gif)

Transition between states can be easily achieved by simply updating the view controller's current state.

```swift
let animations = { [weak self] in
	self?.state = .ready
	self?.view.layoutIfNeeded()
}
        
self.view.layoutIfNeeded()
UIView.animate(withDuration: 0.3,
               delay: 0.0,
               options: .curveEaseInOut,
               animations: animations,
               completion: nil)

```

## License
ViewControllerStates is released under the MIT license. See [license](/LICENSE) for details.