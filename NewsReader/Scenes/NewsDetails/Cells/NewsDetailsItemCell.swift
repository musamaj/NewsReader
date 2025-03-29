//
//  NewsDetailsItemCell.swift
//  NewsReader
//
//  Created by Usama Jamil on 06/03/2022.
//

import Foundation
import UIKit
import Kingfisher


class NewsDetailsItemCell: RxUITableViewCell {
    
    
    // MARK: - UI Control
    
    lazy var newsTitleLbl: UILabel = UILabelFactory.createUILabel(with: .black, textStyle: .title3, weight: .bold, numberOfLines: 2, text:  "new news")
    lazy var newsDescLbl: UILabel = UILabelFactory.createUILabel(with: .black, textStyle: .large, numberOfLines: 0, text:  "news description")
    lazy var newsImage: UIImageView = UIImageViewFactory.createImageView(mode: .scaleToFill, image: nil, tintColor: .clear)
    
    
    // MARK: - Properties
    
    var viewModel: NewsDetailsItemCellViewModelType!
    
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Configuration
    
    override public func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? NewsDetailsItemCellViewModelType else { return }
        self.viewModel = viewModel
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    // MARK: - Setup methods
    
    func setupViews() {
        self.contentView.addSubview(newsTitleLbl)
        self.contentView.addSubview(newsImage)
        self.contentView.addSubview(newsDescLbl)
    }
    
    func setupConstraints() {
        
        newsTitleLbl
        .alignEdgesWithSuperview([.left, .right, .top], constant: 25)
        
        newsImage
            .alignEdgesWithSuperview([.left, .right], constant: 25)
            .toBottomOf(newsTitleLbl, constant: 15)
            .height(constant: 250)
        
        newsDescLbl
            .alignEdgesWithSuperview([.left, .right, .bottom], constant: 25)
            .toBottomOf(newsImage, constant: 15)
    }
    
    func bind() {
        viewModel.outputs.imageUrl.subscribe({ [weak self] event in
            let url = URL(string: event.element ?? "")
            self?.newsImage.kf.setImage(with: url)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.newsTitle.bind(to: newsTitleLbl.rx.text).disposed(by: disposeBag)
        viewModel.outputs.newsDesc.bind(to: newsDescLbl.rx.text).disposed(by: disposeBag)
    }
}
