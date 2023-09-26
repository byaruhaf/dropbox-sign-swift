// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

struct AuthMiddleware: ClientMiddleware {
    
    let apiKey: String
    
    func intercept(_ request: Request, baseURL: URL, operationID: String, next: (Request, URL) async throws -> Response) async throws -> Response {
        let username = apiKey
        let password = ""
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        var request = request
        request.headerFields.append(.init(
            name: "Authorization", value: "Basic \(base64LoginString)"))
        return try await next(request, baseURL)
    }
}



public struct HelloSignClient {
    
    let client: Client
    
    public init(apiKey: String) {
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport(),
            middlewares: [AuthMiddleware(apiKey: apiKey)])
    }
    
    public func accountGet() async throws {
        print("accountGet")
        let response = try await client.accountGet(.init())
        dump(response)
        
        switch response {
        case .ok(let response):
            switch response.body {
            case .json(let jsonresponse):
                print(jsonresponse)
            default:
                throw "Unknown response"
            }
        default:
            throw "Failed to generate image"
        }
    }
    
    public func signatureRequest() async throws {
        print("signatureRequest")
        let response = try await client.signatureRequestSend(.init(body: .json(.init(file_urls: ["https://www.dropbox.com/s/ad9qnhbrjjn64tu/mutual-NDA-example.pdf?dl=1"], signers: [.init(name: "Franklin", email_address: "byaruhaf@gmail.com")], cc_email_addresses: ["byaruhaf@protonmail.com"], client_id: "42708dbeb9683968ec04b38b24a879b4", message: "Please sign this NDA and then we can discuss more. Let me know if you have any questions.", metadata: .init(additionalProperties: ["custom_id": "1234", "custom_text": "NDA #9"]), signing_options: .init(default_type: .draw, draw: true, phone: true, _type: true, upload: true), subject: "The NDA we talked about", test_mode: true, title: "NDA with Acme Co."))))
        dump(response)
    }
    
    public func checkSignatureRequest() async throws {
        print("checkSignatureRequest")
        let response = try await client.signatureRequestGet(.init(path: .init(signature_request_id: "9dff2d7fad476306d7fd2a2717ac2ea558f6a640")))
        dump(response)
    }
    
}

extension String: LocalizedError {
    
    public var errorDescription: String? { self }
}

