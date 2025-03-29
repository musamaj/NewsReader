//
//  ViewController.swift
//  NewsReader
//
//  Created by Usama Jamil on 28/02/2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NewsListingController: UIViewController, UITableViewDelegate {

    
    //MARK: UI Controls
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    lazy var newsButton: UIButton = UIButtonFactory.createButton(title: "News", backgroundColor: .white, textColor: .blue)
    
    private lazy var savedNewsButton: UIButton = UIButtonFactory.createButton(title: "Saved News", backgroundColor: .white, textColor: .black)
    
    private lazy var buttonsStack: UIStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .fill ,distribution: .fillEqually, spacing: 0, arrangedSubviews: [newsButton, savedNewsButton])
    
    var spinner = UIActivityIndicatorView()
    
    //MARK: Properties
    
    
    var disposeBag = DisposeBag()
    private var viewModel : NewsListViewModelType!
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    
    
    //MARK: Init
    
    
    init(viewModel: NewsListViewModelType) {
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
        
        viewModel.inputs.fetchObserver.onNext(())
        
        setupViews()
        setConstraints()
        configureTableView()
        bindTableView()
        bindActions()
    }
    
    func setupViews() {
        newsButton.setTitleColor(.black, for: .normal)
        newsButton.setTitleColor(.blue, for: .selected)
        savedNewsButton.setTitleColor(.black, for: .normal)
        savedNewsButton.setTitleColor(.blue, for: .selected)
        self.newsButton.isSelected = true
        
        self.view.addSubview(tableView)
        self.view.addSubview(buttonsStack)
    }
    
    func setConstraints() {
        tableView
        .alignEdgesWithSuperview([.left, .right])
        .alignEdgeWithSuperviewSafeArea(.top)
        
        buttonsStack
            .alignEdgesWithSuperview([.left, .right, .bottom])
        .toBottomOf(tableView, constant: 20)
        .height(constant: 80)
    }
    
    func configureTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(NewsItemCell.self, forCellReuseIdentifier: NewsItemCell.reuseIdentifier)
    }
    
    func bindTableView() {
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (_, tableView, _, viewModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reusableIdentifier) as! RxUITableViewCell
            cell.configure(with: viewModel)
            return cell
        })
        
        tableView.rx.modelSelected(ReusableTableViewCellViewModelType.self).filter { $0 is NewsItemCellViewModel }.map {
            ($0 as! NewsItemCellViewModel).newsDetails
        }.bind(to: viewModel.inputs.cellSelectionObserver).disposed(by: disposeBag)

        viewModel.outputs.dataSource.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell.subscribe { [weak self] event in
            guard let self = self else {return}
            if self.newsButton.isSelected {
                if event.element?.indexPath.row == self.tableView.numberOfRows(inSection: 0)-1 {
                    self.viewModel.inputs.fetchObserver.onNext(())
                }
            }
        }.disposed(by: disposeBag)
    }

    func bindActions() {
        
        newsButton.rx.tap.subscribe { [weak self] event in
            
            guard let self = self else {return}
            self.savedNewsButton.isSelected = false
            self.newsButton.isSelected = true
            self.viewModel.inputs.newsObserver.onNext(())
            
        }.disposed(by: disposeBag)
        
        savedNewsButton.rx.tap.subscribe { [weak self] event in
            
            guard let self = self else {return}
            self.newsButton.isSelected = false
            self.savedNewsButton.isSelected = true
            self.viewModel.inputs.savedNewsObserver.onNext(())
            
        }.disposed(by: disposeBag)
    }

}

