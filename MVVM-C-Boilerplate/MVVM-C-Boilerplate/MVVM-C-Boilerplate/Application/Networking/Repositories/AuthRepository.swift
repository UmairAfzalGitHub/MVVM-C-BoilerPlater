
import Foundation

class AuthRepository {

    let networkService: NetworkService = DefaultNetworkService()
    
    func signup(imageData: Data, userName: String, email: String, completion: @escaping (Result<SignupResponse, Error>) -> Void) {
        let signUpRequest = SignupRequest(body: ["username": userName, "email": email])
        let multipart = MultipartFormData(
            name: "profile_image",
            filename: "profile.jpg",
            mimeType: "image/jpeg",
            data: imageData
        )
        
        networkService.upload(signUpRequest, multipartData: [multipart]) { result in
            completion(result)
        }
    }
}
