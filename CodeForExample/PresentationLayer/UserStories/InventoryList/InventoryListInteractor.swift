//
//  InventoryListInteractor.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Foundation

protocol InventoryListInteractorProtocol {
    func getInventoryItemsFor(roomId: Int, handoverId: Int, completion: @escaping ResultCallback<[InventoryItem], SomeError>)
    func getRoomsFor(handoverId: Int, completion: @escaping ResultCallback<[Room], SomeError>)
    func addClaim(_ claimText: String, forItem itemId: Int, handoverId: Int, completion: @escaping ResultCallback<ClaimListItem, SomeError>)
    func editClaim(_ claimText: String, claimId: Int, handoverId: Int, completion: @escaping ResultCallback<ClaimListItem, SomeError>)
}

final class InventoryListInteractor: InventoryListInteractorProtocol {
    // MARK: - Private Properties
    private let service: InventoryListAPIProtocol
    
    // MARK: - Initialization
    init(service: InventoryListAPIProtocol) {
        self.service = service
    }
    
    func getInventoryItemsFor(roomId: Int, handoverId: Int, completion: @escaping ResultCallback<[InventoryItem], SomeError>) {
        service.getInventoryItemsFor(roomId: roomId, handoverId: handoverId, completion: completion)
    }
    
    func getRoomsFor(handoverId: Int, completion: @escaping ResultCallback<[Room], SomeError>) {
        service.getRoomsFor(handoverId: handoverId, completion: completion)
    }
    
    func addClaim(_ claimText: String,
                  forItem itemId: Int,
                  handoverId: Int,
                  completion: @escaping ResultCallback<ClaimListItem, SomeError>) {
        
        self.service.addClaim(claimText, forItem: itemId, handoverId: handoverId, completion: completion)
        
    }
    
    func editClaim(_ claimText: String, claimId: Int, handoverId: Int, completion: @escaping ResultCallback<ClaimListItem, SomeError>) {
        self.service.editClaim(claimText, claimId: claimId, handoverId: handoverId, completion: completion)
    }
}
