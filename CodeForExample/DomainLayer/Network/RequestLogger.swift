//
//  RequestLogger.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Foundation
import Alamofire

class RequestLogger: EventMonitor, Injectable {
    
    let queue = DispatchQueue(label: "")
    
    func requestDidFinish(_ request: Request) {
        debugPrint(request.description)
    }
    
    required init() {}
    
    func request<Value>(_ request: DataRequest,
                        didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        
        if let json = try? JSONSerialization.jsonObject(
            with: data,
            options: .mutableContainers) {
            
            debugPrint(json)
        }
    }
}
