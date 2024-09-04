//
//  Multipart Request.swift
//  MVVMBoilerplate
//
//  Created by Umair Afzal on 23/08/2024.
//

import Foundation

struct SignupRequest: DataRequest {
    typealias Response = SignupResponse
    
    var url: String { return "https://api.example.com/signup" }
    var method: HTTPMethod { return .post }
    var headers: [String: String]? { return ["Authorization": "Bearer token"] }
    var queryItems: [String: String] { return [:] }
    var body: [String: Any]
    
    func decode(_ data: Data) throws -> SignupResponse {
        return try JSONDecoder().decode(SignupResponse.self, from: data)
    }
}

struct SignupResponse : Codable {
}
