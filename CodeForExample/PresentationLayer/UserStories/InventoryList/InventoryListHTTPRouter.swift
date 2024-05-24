//
//  InventoryListHTTPRouter.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Foundation
import Alamofire

enum InventoryListHTTPRouter {
    case getRooms(handoverId: Int)
    case getInventoryItems(handoverId: Int, roomId: Int)
}

extension InventoryListHTTPRouter: HttpRouter {
    var path: String {
        switch self {
        case .getInventoryItems(let handoverId, let roomId):
            return "v1/seeker/handovers/\(handoverId)/rooms/\(roomId)/inventory-items"
        case .getRooms(let handoverId):
            return "v1/seeker/handovers/\(handoverId)/rooms"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders? {
        return [
            "Authorization": "Bearer \(TokenManager.shared.token)",
            "Content-Type": "application/json; charset=UTF-8",
            "Accept": "application/json; charset=UTF-8"
        ]
    }
    
}
