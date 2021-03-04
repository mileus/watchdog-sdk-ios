
import Foundation


protocol NetworkingClient {
    typealias RequestResponse = Result<(Data, HTTPURLResponse), Error>
    
    func request(endpoint: Endpoint, completion: @escaping (RequestResponse) -> Void)
}


final class HTTPClient: NetworkingClient {
    
    private struct UnexpectedValues: Error {}
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(endpoint: Endpoint, completion: @escaping (NetworkingClient.RequestResponse) -> Void) {
        session.dataTask(with: convert(endpoint: endpoint)) { (data, response, error) in
            completion(Result(catching: {
                if let error = error {
                    throw error
                } else if let data = data, let httpResponse = response as? HTTPURLResponse {
                    return (data, httpResponse)
                } else {
                    throw UnexpectedValues()
                }
            }))
        }
    }
    
    private func convert(endpoint: Endpoint) -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.key
        request.httpBody = endpoint.body
        return request
    }
}

private extension HTTPMethod {
    
    var key: String {
        switch self {
        case .post:
            return "post"
        }
    }
    
}
