//
//  InventoryListPresenter.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Foundation

protocol InventoryListPresenterProtocol {
    func openMyClaims()
    func openRoomSelection()
    func reloadItems()
    func showClaimPopup(itemIndex: Int)
    func confirmButtonTapped()
}

final class InventoryListPresenter {
    
    private weak var viewController: InventoryListViewControllerProtocol?
    private let router: InventoryListRouterProtocol
    private let interactor: InventoryListInteractorProtocol
    private let handoverId: Int
    
    private(set) var selectedRoom: Room?
    
    private(set) var inventoryItems: [InventoryItem] = [] {
        didSet {
            viewController?.reloadView()
        }
    }
    
    // MARK: - Initialization
    
    init(viewController: InventoryListViewControllerProtocol,
         router: InventoryListRouterProtocol,
         interactor: InventoryListInteractorProtocol,
         handoverId: Int) {
        self.viewController = viewController
        self.router = router
        self.interactor = interactor
        self.handoverId = handoverId
    }
    
}

extension InventoryListPresenter: InventoryListPresenterProtocol {
    func openMyClaims() {
        router.openMyClaims(handoverId: handoverId)
    }
    
    func openRoomSelection() {
        viewController?.showLoader()
        interactor.getRoomsFor(handoverId: handoverId) { [weak self] response in
            self?.viewController?.hideLoader()
            switch response {
            case .success(let rooms):
                if !rooms.isEmpty {
                    self?.router.openRoomSelection(rooms: rooms, selectionHandler: { selectedRoom in
                        self?.selectedRoom = selectedRoom
                        self?.reloadItems()
                    })
                }
            case .failure(let error):
                LOG.error(error.localizedDescription)
            }
        }
    }
    
    func showClaimPopup(itemIndex: Int) {
        var item = self.inventoryItems[itemIndex]
        router.showClaimPopup(claim: item.claim, onFinishEnteringText: { [weak self] claimText in
            guard let self else { return }
            self.viewController?.showLoader()
            self.handleClaimUpdate(inventoryItem: item, claimText: claimText) { response in
                self.viewController?.hideLoader()
                switch response {
                case .success(let claim):
                    item.claim = InventoryClaim(id: claim.id, description: claim.description)
                    self.inventoryItems[itemIndex] = item
                case .failure(let error):
                    LOG.error(error.localizedDescription)
                }
            }
        })
    }
    
    func confirmButtonTapped() {
        self.router.popViewController()
    }
    
    func reloadItems() {
        viewController?.showLoader()
        interactor.getInventoryItemsFor(roomId: selectedRoom?.id ?? 0,
                                        handoverId: handoverId) { [weak self] itemsResponse in
            self?.viewController?.hideLoader()
            switch itemsResponse {
            case .success(let items):
                self?.inventoryItems = items
            case .failure(let error):
                LOG.error(error.localizedDescription)
            }
        }
    }
    
    private func handleClaimUpdate(inventoryItem: InventoryItem,
                                   claimText: String,
                                   completion: @escaping ResultCallback<ClaimListItem, SomeError>) {
        if let claim = inventoryItem.claim {
            self.interactor.editClaim(claimText,
                                      claimId: claim.id,
                                      handoverId: self.handoverId,
                                      completion: completion)
        } else {
            self.interactor.addClaim(claimText, forItem: inventoryItem.id,
                                     handoverId: handoverId, completion: completion)
        }
    }
}
