
import Foundation

enum HTTPMethod {
    case post
}


protocol Endpoint {
    
    var baseUrl: String { get }
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var body: Data? { get }
    
    var headers: [String : String]? { get }
    
}

extension Endpoint {
    var url: URL {
        URL(string: baseUrl)!.appendingPathComponent(path)
    }
}
