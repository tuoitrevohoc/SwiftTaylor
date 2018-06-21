# SwiftTaylor

A lightweight Swift on the server that uses `swift-nio` and latest Swift features.

Sample hello world:

```swift
import SwiftTaylor

let server = Server(port: 8080)

server.use { _, response, _ in
    response.send("Hello World!")
}

try! server.listen()
```

With a router:

```swift
import SwiftTaylor

let server = Server(port: 8080)
var router = Router()

router.get("/") { _, response in
    response.send("Hello World!")
}

router.get("/:name") { request, response in
    response.send("Hello \(request.parameters["name"]!)")
}

try! server.listen()
```
