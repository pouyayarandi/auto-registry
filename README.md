# AutoRegistry

This project is a demo to show how we can make `Factory` safer with the help of code generators. 
In this project we have a DomainLibrary which is using CoreLibrary inside its implementation and it's being used in the project.

## How does it work?

It's rely on two tools: ServiceMacro and AutoRegistery.

- **ServiceMacro:** a swift macro library that is being used to annotate the public service protocols and implementations.
  It generates a Factory's `Container` to define the service and a registry for the implementation.
- **AutoRegistery:** a command plugin which generates the code for service registerations based on occurances of `@Service` through the codebase.
  It also provides a build tool plugin which compare hashes of file and desired state and fails the compile if the generated code is outdated.
  The generated code could be found in `Registry.generated.swift` file inside AutoRegistery package.

## How to add a service?

Let's say you want to add a service to the project. You should follow these steps:

### 1. Add a new package

Add a swift package for the service. We will use it in the next steps.

### 2. Add a public module

Add a module for the public layer of the service. It contains protocols which will be available from the outside.
Here you should add `@Service` to annotate the service protocol.

```swift
@Service
public protocol MyService {
  func helloWorld()
}
```

### 3. Implement your service

Add another module in your package and implement the service. Note that this module should be named in `<ServiceName>_Imp` format.
In this case the module should be named `MyService_Imp`.

```swift
@Implementation(MyService.self)
public struct MyService_Imp: MyService {
  func helloWorld() {
    print("Hello World!")
  }
}
```

### 4. Regenerate the Registery.swift file

Now, if you build your project it fails, because your new service is not in Registery.swift file and it's outdated.
First, you need to regenerate this file using Xcode (right click on Dependency project in Project Navigator and then click on AutoRegistery)
or terminal using:

```
swift package generate-registery
```

### 5. Add dependency to Registery.swift

Your project still fails as generated code imports `MyService_Imp`. 
Just add it to the dependencies of Registery target in AutoRegistery's Package.swift file.

```swift
.target(
  name: "Registery",
  dependencies: [
    .product(name: "MyService_Imp", package: "MyService"),
    ...
  ]
)
```

And now your project works! You can use the new service everywhere with Factory's Container.

```swift
@Injected(\MyService_Container.myService) var myService
```

