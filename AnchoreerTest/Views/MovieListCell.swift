//
//  MovieListCell.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation
import UIKit
import RxSwift

class MovieListCell: UITableViewCell {
    
    static let identifier: String = "MovieListCell"
    
    private var infoView: MovieInfoView = MovieInfoView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(infoView)
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        infoView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        infoView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        infoView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        infoView.clearData()
    }
    
    public func configureCell(with vm: MovieViewModel) {
        
        infoView.configureData(with: vm)
    }
    
}
