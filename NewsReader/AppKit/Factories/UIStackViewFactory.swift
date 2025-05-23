//
//  UIStackViewFactory.swift
//  NewsReader
//
//  Created by Usama Jamil on 28/02/2022.
//

import Foundation
import UIKit

public class UIStackViewFactory {
    public class func createStackView(with axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .leading, distribution: UIStackView.Distribution = .fillProportionally, spacing: CGFloat = 0, arrangedSubviews: [UIView]? = nil) -> UIStackView {
        let stackView = arrangedSubviews == nil ? UIStackView() : UIStackView(arrangedSubviews: arrangedSubviews!)
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
