import SwiftTaylor

struct Message: Codable {
    let content: String
}

let server = Server(port: 8080)

var router = Router()

router.get("/") { _, response in
    response.send(status: .ok, content: "Hello World!")
}

router.get("/object") { _, response in
    response.send(status: .ok, content: Message(content: "Hello World!"))
}

router.get("/:name") { request, response in
    let name = request.parameters["name"]!
    response.send(status: .ok, content: "Hello \(name)!")
}

server.use(router: router)
try server.listen()
