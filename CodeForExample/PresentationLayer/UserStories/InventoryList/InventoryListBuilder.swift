//
//  InventoryListBuilder.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import UIKit

enum InventoryListBuilder {
    static func build(handoverId: Int) -> UIViewController {
        let viewController: InventoryListViewController = R.storyboard.inventoryList().loadViewController()
        viewController.title = Localized.inventoryList(preferredLanguages: [Language.shared.currentLanguage])
        
        let interactor = InventoryListInteractor(service: InventoryListService.shared)
        let router = InventoryListRouter(viewController: viewController)
        let presenter = InventoryListPresenter(
            viewController: viewController,
            router: router,
            interactor: interactor,
            handoverId: handoverId
        )
        viewController.presenter = presenter
        return viewController
    }
}
