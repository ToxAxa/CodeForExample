//
//  InventoryListViewController.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import UIKit

protocol InventoryListViewControllerProtocol: NSObject {
    func reloadView()
    func showLoader()
    func hideLoader()
}

final class InventoryListViewController: UIViewController {
    
    @IBOutlet weak var roomSelectionField: TenantProfilePressedTextControl!
    
    @IBOutlet weak var myClaimsDeepColorButton: DeepButtonColor!
    @IBOutlet weak var confirmDeepColorButton: DeepButtonColor!
    @IBOutlet weak var inventoryListTableView: UITableView!
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    private let heigtHeaderSectionValue = 1.0
    private var selectedRoom: Room? {
        didSet {
            inventoryListTableView.reloadData()
        }
    }
    
    // MARK: Public proporties
    var presenter: InventoryListPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = presenter?.selectedRoom {
            presenter?.reloadItems()
        }
    }
    
    private func configureViews() {
        configureRoomPressedTextControl()
        configureButtons()
        configureTableView()
        configureRightBarButtonItem()
        emptyView.isHidden = false
    }
    
    private func configureRoomPressedTextControl() {
        roomSelectionField.configurate(
            dataTitle: Localized.chooseRoom(preferredLanguages: [Language.shared.currentLanguage]),
            serverValueData: (TenantProfileFieldType.employmentType.rawValue, nil),
            validationRules: [RequiredRule()],
            requirementsType: .employmentType, styleField: .profile) {
                [weak self] in
                self?.presenter?.openRoomSelection()
            }
        
        roomSelectionField.isEditable = true
        roomSelectionField.isHidden = false
    }
    
    private func configureButtons() {
        
        myClaimsDeepColorButton.configure(
            config: .init(
                title: Localized.inventoryClaims(preferredLanguages: [Language.shared.currentLanguage]).camelCaseString(),
                action: { [weak self] in
                    self?.presenter?.openMyClaims()
                }
            ),
            style: .greenText()
        )
        
        confirmDeepColorButton.configure(
            config: .init(
                title: Localized.confirm_come_back(preferredLanguages: [Language.shared.currentLanguage]),
                action: { [weak self] in
                    self?.presenter?.confirmButtonTapped()
                }),
            style: .green()
        )
    }
    
    private func configureTableView() {
        inventoryListTableView.delegate = self
        inventoryListTableView.dataSource = self
        inventoryListTableView.registerNib(InventoryListItemTableViewCell.self)
        inventoryListTableView.allowsSelection = false
    }
    
    private func configureRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: R.image.infoIconSVG(),
            style: .plain,
            target: self,
            action: #selector(infoIconTapped)
        )
    }
    
    @objc func infoIconTapped() {
        LOG.debug("info icon tapped")
    }
    
}

extension InventoryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let items = presenter?.inventoryItems else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InventoryListItemTableViewCell = tableView.dequeueCell(at: indexPath)
        if let items = presenter?.inventoryItems {
            cell.configure(item: items[indexPath.section], editAction: { [weak self] _ in
                self?.presenter?.showClaimPopup(itemIndex: indexPath.section)
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heigtHeaderSectionValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension InventoryListViewController: InventoryListViewControllerProtocol {
    func reloadView() {
        if let room = presenter?.selectedRoom {
            roomSelectionField.text = room.name
            emptyView.isHidden = !(presenter?.inventoryItems.isEmpty ?? true)
        } else {
            emptyView.isHidden = true
        }
        inventoryListTableView.reloadData()
    }
    
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.showLottieLoader()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLottieLoader()
        }
    }
}
