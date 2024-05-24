//
//  InventoryListService.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Foundation

protocol InventoryListAPIProtocol {
    func getInventoryItemsFor(roomId: Int, handoverId: Int, completion: @escaping ResultCallback<[InventoryItem], SomeError>)
    func getRoomsFor(handoverId: Int, completion: @escaping ResultCallback<[Room], SomeError>)
    func addClaim(_ claimText: String, forItem itemId: Int, handoverId: Int, completion: @escaping ResultCallback<ClaimListItem, SomeError>)
    func editClaim(_ claimText: String, claimId: Int, handoverId: Int, completion: @escaping ResultCallback<ClaimListItem, SomeError>)
}

final class InventoryListService: InventoryListAPIProtocol {
    private let httpService: HttpService
    private let claimsService: MyClaimsAPIProtocol
    static let shared: InventoryListService = InventoryListService()
    
    init(httpService: HttpService = HttpService(), claimsService: MyClaimsAPIProtocol = MyClaimsService.shared) {
        self.httpService = httpService
        self.claimsService = claimsService
    }
    
    func getInventoryItemsFor(roomId: Int, handoverId: Int, completion: @escaping ResultCallback<[InventoryItem], SomeError>) {
        do {
            try InventoryListHTTPRouter
                .getInventoryItems(handoverId: handoverId, roomId: roomId)
                .request(usingHttpService: self.httpService)
                .responseJSON(completionHandler: { response in
                    guard let statusCode = response.response?.statusCode else {
                        completion(.failure(.objectMapping))
                        return
                    }
                    switch statusCode {
                    case 200...201:
                        guard let model: [InventoryItem] = DecoderHelper.decode(
                            result: response,
                            model: [InventoryItem].self
                        ) else {
                            completion(.failure(.objectMapping))
                            return
                        }
                        completion(.success(model))
                    default:
                        completion(.failure(.someString(errorString: "Error status code is \(statusCode)")))
                    }
                })
            
        } catch let error {
            completion(.failure(.someString(errorString: error.localizedDescription)))
        }
    }
    
    func getRoomsFor(handoverId: Int, completion: @escaping ResultCallback<[Room], SomeError>) {
        do {
            try InventoryListHTTPRouter
                .getRooms(handoverId: handoverId)
                .request(usingHttpService: self.httpService)
                .responseJSON(completionHandler: { response in
                    guard let statusCode = response.response?.statusCode else {
                        completion(.failure(.objectMapping))
                        return
                    }
                    switch statusCode {
                    case 200...201:
                        guard let model: [Room] = DecoderHelper.decode(
                            result: response,
                            model: [Room].self
                        ) else {
                            completion(.failure(.objectMapping))
                            return
                        }
                        completion(.success(model))
                    default:
                        completion(.failure(.someString(errorString: "Error status code is \(statusCode)")))
                    }
                })
            
        } catch let error {
            completion(.failure(.someString(errorString: error.localizedDescription)))
        }
    }
    
    func addClaim(_ claimText: String,
                  forItem itemId: Int,
                  handoverId: Int,
                  completion: @escaping ResultCallback<ClaimListItem, SomeError>) {
        claimsService.addClaim(claimText, forItem: itemId, handoverId: handoverId, completion: completion)
    }
    
    func editClaim(_ claimText: String,
                   claimId: Int,
                   handoverId: Int,
                   completion: @escaping ResultCallback<ClaimListItem, SomeError>) {
        claimsService.editClaim(claimText, claimId: claimId, handoverId: handoverId, completion: completion)
    }
}
