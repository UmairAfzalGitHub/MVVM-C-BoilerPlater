
import Foundation

struct ProductsRequest: DataRequest {
    
    var url: String {
        let baseURL: String = NetworkConstants.apiBaseURL
        let path: String = NetworkConstants.EndPoints.products
        return baseURL + path
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func decode(_ data: Data) throws -> ProductsReponse {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let response = try decoder.decode(ProductsReponse.self, from: data)
        return response
    }
}


// SAMPLE Response Model

struct ProductsReponse : Codable {
    let filters : [String]?

    enum CodingKeys: String, CodingKey {
        case filters = "filters"
    }

    init() {
        filters = nil
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        filters = try values.decodeIfPresent([String].self, forKey: .filters)
    }

}
