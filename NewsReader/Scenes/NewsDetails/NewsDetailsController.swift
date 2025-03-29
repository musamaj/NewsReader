//
//  NewsDetailsController.swift
//  NewsReader
//
//  Created by Usama Jamil on 06/03/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NewsDetailsController: UIViewController, UITableViewDelegate {

    
    //MARK: UI Controls
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let menuButton = UIButton(type: .custom)
        menuButton.setTitle("Save", for: .normal)
        menuButton.setTitleColor(.blue, for: .normal)
        //menuButton.tintColor = .blue
        menuButton.frame = CGRect(x: 0.0, y: 0.0, width: 26, height: 26)
        menuButton.addTarget(self, action: #selector(self.saveAction(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: menuButton)
    }()
    
    
    //MARK: Properties
    
    
    var disposeBag = DisposeBag()
    private var viewModel : NewsDetailsViewModelType!
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    
    
    //MARK: Init
    
    
    init(viewModel: NewsDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        setupViews()
        setConstraints()
        configureTableView()
        bindTableView()
    }
    
    func setupViews() {
        addBackButton()
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        self.view.addSubview(tableView)
    }
    
    func setConstraints() {
        tableView
        .alignEdgesWithSuperview([.left, .right, .bottom])
        .alignEdgeWithSuperviewSafeArea(.top)
    }
    
    func configureTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(NewsDetailsItemCell.self, forCellReuseIdentifier: NewsDetailsItemCell.reuseIdentifier)
    }
    
    func bindTableView() {
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (_, tableView, _, viewModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusableIdentifier) as! RxUITableViewCell
            cell.configure(with: viewModel)
            return cell
        })

        viewModel.outputs.dataSource.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    override func onTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc
    func saveAction(_ sender: UIButton) {
        viewModel.inputs.saveObserver.onNext(())
        self.showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "", message: "Item Saved", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

