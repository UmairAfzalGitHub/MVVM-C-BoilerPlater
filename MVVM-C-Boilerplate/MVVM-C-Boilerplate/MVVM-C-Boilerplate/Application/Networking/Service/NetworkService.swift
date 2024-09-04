
import Foundation

struct MultipartFormData {
    let name: String           // The name of the form field
    let filename: String?     // The filename for file uploads (e.g., "profile.jpg")
    let mimeType: String?     // The MIME type of the file (e.g., "image/jpeg")
    let data: Data            // The actual data to upload
}


protocol NetworkService: AnyObject {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)

    func upload<Request: DataRequest>(
          _ request: Request,
          multipartData: [MultipartFormData],
          completion: @escaping (Result<Request.Response, Error>) -> Void
      )
}

final class DefaultNetworkService: NetworkService {
    
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidEndpoint)))
        }
        
        var queryItems: [URLQueryItem] = []
        
        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidQueryItems)))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        
        if request.method == .post {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: request.body, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch let error {
                return completion(.failure(error))
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse,
                  200..<300 ~= response.statusCode else {
                      return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidResponse)))
                  }
            
            guard let data = data else {
                return completion(.failure(NSError.createError(ofType: ErrorResponse.noData)))
            }
            
            do {
                let decodedData = try request.decode(data)
                completion(.success(decodedData))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func upload<Request: DataRequest>(
            _ request: Request,
            multipartData: [MultipartFormData],
            completion: @escaping (Result<Request.Response, Error>) -> Void
        ) {
            // 1. Construct the URL with query parameters
            guard var urlComponent = URLComponents(string: request.url) else {
                return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidEndpoint)))
            }
            
            var queryItems: [URLQueryItem] = []
            request.queryItems.forEach {
                queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            }
            urlComponent.queryItems = queryItems.isEmpty ? nil : queryItems
            
            guard let url = urlComponent.url else {
                return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidQueryItems)))
            }
            
            // 2. Create and configure the URLRequest
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.headers
            
            // 3. Generate a unique boundary string using UUID
            let boundary = "Boundary-\(UUID().uuidString)"
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // 4. Build the multipart form data body
            var body = Data()
            
            // 4a. Append regular form fields
            for (key, value) in request.body {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value ?? "")\r\n")
            }
            
            // 4b. Append files
            for part in multipartData {
                body.append("--\(boundary)\r\n")
                
                if let filename = part.filename, let mimeType = part.mimeType {
                    body.append("Content-Disposition: form-data; name=\"\(part.name)\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimeType)\r\n\r\n")
                } else {
                    body.append("Content-Disposition: form-data; name=\"\(part.name)\"\r\n\r\n")
                }
                
                body.append(part.data)
                body.append("\r\n")
            }
            
            // 4c. Append the closing boundary
            body.append("--\(boundary)--\r\n")
            
            urlRequest.httpBody = body
            
            // 5. Perform the network request
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                // Handle errors from the network request
                if let error = error {
                    return completion(.failure(error))
                }
                
                // Validate the HTTP response status code
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    return completion(.failure(NSError.createError(ofType: ErrorResponse.invalidResponse)))
                }
                
                // Ensure data was received
                guard let data = data else {
                    return completion(.failure(NSError.createError(ofType: ErrorResponse.noData)))
                }
                
                // Attempt to decode the response
                do {
                    let decodedData = try request.decode(data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
            .resume()
        }
}
