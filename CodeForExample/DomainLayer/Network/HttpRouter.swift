//
//  HttpRouter.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Alamofire
import Foundation

protocol HttpRouter: URLRequestConvertible {
    var baseURLString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parametrs: Parameters? { get }
    var multipartFormData: MultipartFormData? { get }
    
    func body() throws -> Data?
    func request(usingHttpService service: HttpServiceProtocol) throws -> DataRequest
}

extension HttpRouter {
    var baseURLString: String { AppEnvironmentManager.shared.currentEnvironment.baseUrl }
    var parametrs: Parameters? { return nil }
    var multipartFormData: MultipartFormData? { return nil }
    
    func body() throws -> Data? { return nil }
    
    func asURLRequest() throws -> URLRequest {
        
       let urlComponents = NSURLComponents(string: baseURLString + path)

        if let parametrsArray = parametrs, !parametrsArray.isEmpty {
            urlComponents?.queryItems = []
            
            for parametr in parametrsArray {
                let item = URLQueryItem(
                    name: parametr.key,
                    value: "\(parametr.value)"
                )
                urlComponents?.queryItems?.append(item)
            }
        }
        
        guard let urlRequest = urlComponents?.url else {
            throw AppError.localizedError(localizedTitle: "Bad url in request \(#function)")
        }
        
        var headers = headers
        
        headers?["X-User-Timezone"] = "\(TimeZone.current.restIdentifier)"
        headers?["Client"] = "ios"
        headers?["Content-Language"] = Language.shared.currentLanguage
        
        if let appVersion = self.getAppVersion() {
            headers?["Version"] = appVersion
        }
        
        var request = try URLRequest(
            url: urlRequest,
            method: method,
            headers: headers
        )

        request.httpBody = try body()

        if let multipartFormData = multipartFormData {
            request.setValue(
                multipartFormData.contentType,
                forHTTPHeaderField: "Content-Type"
            )
            request.httpBody = try multipartFormData.encode()
        }
        
        LOG.info("Request<\(method.rawValue)>: \(baseURLString + path) 🚹 TOKEN = '\(String(describing: TokenManager.shared.token))'")
        
        if let token = TokenManager.shared.token, !token.isEmpty {
            request.setValue(
                "Bearer \(token)",
                             forHTTPHeaderField: "Authorization"
            )
        }
        
        LOG.info("Headers: \(request.allHTTPHeaderFields)")
        if let body = request.httpBody {
            LOG.info("Body: \(String(data: body, encoding: .utf8))")
        }
        
        return request
    }
    
    func request(usingHttpService service: HttpServiceProtocol) throws -> DataRequest {
        return try service.request(asURLRequest())
    }
}

fileprivate extension HttpRouter {
    func getAppVersion() -> String? {
        guard let version = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String else { return nil }
        return version
    }
    
    func getBuild() -> String? {
        guard let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return nil }
        return buildNumber
    }
    
    func getFullVersion() -> String? {
        guard let version = getAppVersion(), let build = getBuild() else { return nil }
        return version + "." + build
    }
}

