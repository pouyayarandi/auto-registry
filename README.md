# AutoRegistry

This project is a demo to show how we can make `Factory` safer with the help of code generators.

## How does it work?

It's rely on two tools: ServiceMacro and AutoRegistery.

- **ServiceMacro:** a swift macro that is being used to annotate the public service protocols.
  It generates the needed extensions on Factory's `Container` to define the service.
- **AutoRegistery:** a command plugin which generates the code for service registerations based on occurances of `@Service` through the codebase.
  It also provides a build tool plugin which compare hashes of file and desired state and fails the compile if the generated code is outdated.
  The generated code could be found in `Registery.swift` file inside AutoRegistery package.

## How to add a service?

Let's say you want to add a service to the project. You should follow these steps:

### 1. Add a new package

Add a swift package for the service. We will use it in the next steps.

### 2. Add a public module

Add a module for the public layer of the service. It contains protocols which will be available from the outside.
Here you should add `@Service` to annotate the extension of the `Container`.

```swift
public protocol MyService {
  func helloWorld()
}

@Service(MyService.self)
extension Container {}
```

### 3. Implement your service

Add another module in your package and implement the service.

```swift
public struct MyServiceImp: MyService {
  func helloWorld() {
    print("Hello World!")
  }
}
```

### 4. Add wiring module

You need to define a wiring module for every service you define. Its name should be in format of `<ServiceName>_Wiring`
and should have a struct with the same name of the module which provides a `build()` static function. This function determines
which implementation should be used for the service.

```swift
public struct MyService_Wiring {
  public static func build() -> MyService {
    return MyServiceImp()
  }
}
```

### 5. Regenerate the Registery.swift file

Now, if you build your project it fails, because your new service is not in Registery.swift file and it's outdated.
First, you need to regenerate this file using Xcode (right click on Dependency project in Project Navigator and then click on AutoRegistery)
or terminal using:

```
swift package generate-registery
```

### 6. Add dependency to Registery.swift

Your project still fails as generated code imports `MyService_Wiring`. 
Just add it to the dependencies of Registery target in AutoRegistery's Package.swift file.

And now your project works!

