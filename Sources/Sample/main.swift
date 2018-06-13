import SwiftTaylor

let server = Server(port: 8080)

server.use { request, response in
    response.send(status: .ok, content: "Hello World!")
}

try server.listen()
