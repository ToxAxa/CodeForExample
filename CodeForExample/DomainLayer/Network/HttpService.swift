//
//  HttpService.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Alamofire

typealias AFSession = Alamofire.Session

protocol HttpServiceProtocol {
    
    var sessionManager: Session { get set }
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}

class HttpService: HttpServiceProtocol {
    var sessionManager: Session = AFSession(
        interceptor: Interceptor(),
        eventMonitors: [RequestLogger()]
    )
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return sessionManager
            .request(urlRequest)
            .validate()
            .validateResponse()
    }
}

extension DataRequest {
    @discardableResult
    func validateResponse() -> Self {
        responseData { data in
            if let response = data.response {
                if !response.isResponseOK {
                    ApiErrorHandler.shared.handleError(
                        responseData: data.data,
                        statusCode: response.statusCode
                    )
                }
            }
        }
        return self
    }
}
