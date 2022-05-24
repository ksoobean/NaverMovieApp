//
//  MovieDetailViewModel.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/24.
//

import Foundation


class MovieDetailViewModel {
    
    let movieInfo: MovieViewModel
    let link: String
    
    init(infoVM: MovieViewModel) {
        self.movieInfo = infoVM
        self.link = infoVM.link
    }
}
