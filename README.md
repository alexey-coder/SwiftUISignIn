# SwiftUISignIn
Task
Design a SwiftUI application for iOS that will simulate a Signup form to some network server. Users should be able to type the name and password and the button must be enabled only if the input is valid.
Details
The app should be a single view that contains the following elements: Username text field
Password text field
Verify password text field
Create Account button
Requirements
● passwords in both text fields must match
● password length must be greater than 8 chars
● the following well-known passwords must be explicitly prohibited: "password", "admin"
● user name must be valid according to the response from the server
○ do not send very frequent requests to the server, debounce time must be 500 ms
○ do not request duplicate values
○ simulate server response locally by any asynchronous means, like Future and
promise closure, for example
○ 'server side' logic of the username check must simply prohibit names that are
shorter than 5 chars, somewhat like this:
func usernameAvailable(_ username: String, completion: (Bool) -> Void) {
username.count < 5 ? completion(false) : completion(true) }
● enable Create Account button only if all the above requirements are met.
The app must also
● use only SwiftUI and Combine frameworks
● be without Storyboards
● adhere to MVVM architecture
● preview must be implemented and functioning in the XCode’s canvas
