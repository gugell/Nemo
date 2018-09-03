# Nemo

Nemo is an opinionated iOS programmatically navigation management helper.

> Nemo is a mysterious figure. The son of an Indian Raja, he is a scientific genius who roams the depths of the sea in his submarine, the Nautilus, which was built in pieces all over the world and shipped to the builder

## Motivation

* Avoid boilerplate code when handle navigation programmatically.
* Reduce setup for navgiation between controllers, embrace convention.

## Showcase

### 1. Clone this repo

``` bash
git clone git@github.com:yellowme/Nemo.git
```

### 2. Open and launch

Open the `Nemo.xcodeproj` file and run the app. Use the provided controls to determine the application flow and click on the *Dispatch!* button.

We are using the [Legato](https://github.com/yellowme/legato) approach to dispatch the user through the application screens.

**Note:** We use a [DataFaker](https://github.com/LuisBurgos/Nemo/blob/master/Nemo/Utils/DataFaker.swift) file to mock local data or server information.

### Outcomes

We use [Gherkin](https://docs.cucumber.io/gherkin/reference/) to define a behavior use case.

```gherkin
Feature: Launch application should redirect the user depending on it's state

  Scenario: Display Main screen
    Given the application has finish launching
    When the user has logged in
    And the user has a valid token for the session
    And the user has a valid attribute value
    Then the user should see the Main screen label

  Scenario: Display Login screen
    Given the application has finish launching
    When the user has not logged in
    Then the user should see the Login screen label

  Scenario: Display Login screen
    Given the application has finish launching
    When the user has logged in
    But the user has not a valid token for the session
    Then the user should see the Login screen label

  Scenario: Display Error screen
    Given the application has finish launching
    When the user has logged in
    And the user has a valid token for the session
    But the user has not a valid attribute value
    Then the user should see the Error screen label
```

These scenearios generates the following outcomes:

| Main        | Login  | Error |
| :-------------: |:-----:|:-------------:|
| ![Main](./Assets/Nemo-Main.gif)  | ![Login](./Assets/Nemo-Login.gif) | ![Error](./Assets/Nemo-Error.gif) |

## Usage

### 1. Add source files

Add all the files inside the [Common/Nemo](https://github.com/LuisBurgos/Nemo/tree/master/Nemo/Common/Nemo) folder

### 2. Add your screens

**IMPORTANT:**

`Screen` class provides two ways to declarate a screen.

#### Specific controller inside Storyboard

This approach allows you to register any controller inside a given storyboard file.

You will need:

* An unique key for the screens dictionary on *Nemo*
* The ViewController name
* The Storyboard name file which containts the controller.

**Example:**

```swift
let loginScreen = Screen(
    "LoginViewController",
    "LoginViewController",
    "Login"
)
```

#### Convention over configuration

Image you have a `LoginViewController` identifier for a ViewController inside your `Login.storyboard` file. In order to add this controller reference to Nemo you should to the following:

```swift
let loginScreen = Screen(named: "Login")
```

In this case, *Nemo* assumes that the given *Login* name is the name of the Storyboard which contains a ViewController with a name using a **nomenclature** as follows:

> *UIViewController* name = *Storyboard* name + "ViewController"

So when you create a `Screen` instance with this approach, what *Nemo* does under the hood is using the previous *nomenclature* and calling the first approach *constructor* method as follows:

```swift
let loginScreen = Screen(
    "LoginViewController",
    "LoginViewController",
    "Login"
)
```

#### Setup your AppDelegate

```swift
extension AppDelegate {
    internal func buildNautilus() {
        Nemo.add(
            Screen(named: .dispatch),
            Screen(named: .login),
            Screen(named: .main),
            Screen(named: .error)
        )
    }
}

extension NemoKeys {
    static let dispatch: NemoKeys = NemoKeys("Dispatcher")
    static let login: NemoKeys = NemoKeys("Login")
    static let main: NemoKeys = NemoKeys("Main")
    static let error: NemoKeys = NemoKeys("Error")
}
```

### 3. Call setup method inside your `didFinishLaunchingWithOptions`

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        buildNautilus()
        return true
    }
}
```

### 3. Tell the captian where to go

To change the main controller use:

```swift
Nemo.go(to: .main)
```

## TODO:

* Document use of `embed` cases.
* Document how to push controllers