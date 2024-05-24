//
//  InventoryListRouter.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Foundation
import UIKit

protocol InventoryListRouterProtocol {
    func openMyClaims(handoverId: Int)
    func openRoomSelection(rooms: [Room], selectionHandler: RoomSelectionHandler?)
    func showClaimPopup(claim: Claim?, onFinishEnteringText: StringCallback?)
    func popViewController()
}

final class InventoryListRouter {
    // MARK: - Private properties
    private let viewController: UIViewController
    
    // MARK: - Initialization
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension InventoryListRouter: InventoryListRouterProtocol {
    func openMyClaims(handoverId: Int) {
        let viewController = MyClaimsBuilder.build(handoverId: handoverId)
        self.viewController.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openRoomSelection(rooms: [Room], selectionHandler: RoomSelectionHandler?) {
        let selectionVC = SelectRoomSheetBuilder.build(rooms: rooms, selectionHandler: selectionHandler)!
        self.viewController.present(selectionVC, animated: true)
    }
    
    func showClaimPopup(claim: Claim?, onFinishEnteringText: StringCallback?) {
        let popup = AddClaimPopUpBuilder.build(title: Localized.addDescription(preferredLanguages: [Language.shared.currentLanguage]),
                                               inputTitle: Localized.description(preferredLanguages: [Language.shared.currentLanguage]),
                                               inputPlaceholder: Localized.description_field_defect(preferredLanguages: [Language.shared.currentLanguage]),
                                               addTitle: Localized.makeClaim(preferredLanguages: [Language.shared.currentLanguage]),
                                               cancelTitle: Localized.discard(preferredLanguages: [Language.shared.currentLanguage]),
                                               inputValue: claim?.description,
                                               onFinishEnteringText: onFinishEnteringText)!
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .coverVertical
        viewController.present(popup, animated: true)
    }
    
    func popViewController() {
        self.viewController.navigationController?.popViewController(animated: true)
    }
}
