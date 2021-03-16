//
//  NetworkRouter.swift
//  TestCuriositySnapshot
//
//  Created by Sergey Chvilev on 13.03.2021.
//

import Foundation
import Alamofire

public enum NetworkRouter: URLRequestConvertible {
    private static let baseURLPath = "https://api.nasa.gov/"
    private static var httpMetod = HTTPMethod.get
    
    case snapshotsList(rover: String, page: Int, date: String)
    
    public func asURLRequest() throws -> URLRequest {
         let result: (path: String, parameters: Parameters) = {
            switch self {
            case .snapshotsList(let rover, let page, let date):
                return("mars-photos/api/v1/rovers/\(rover)/photos", ["page": page, "api_key": "DEMO_KEY", "earth_date": date])
            }
        }()
        
        let url = try NetworkRouter.baseURLPath.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = NetworkRouter.httpMetod.rawValue
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
     }
}
