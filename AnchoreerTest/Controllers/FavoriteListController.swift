//
//  BookmarkListController.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FavoriteListViewModel {
    
    let naviTitle: String = "즐겨찾기 목록"
    
    /// 저장된 즐겨찾기 리스트
    var favList: BehaviorRelay<[MovieViewModel]> = BehaviorRelay(value: [])
    
    init() {
        self.getFavoriteMovieList()
    }
    
    private func getFavoriteMovieList() {
        self.favList.accept(Database.shared.load())
    }
}

class FavoriteListController: UIViewController {
    
    private let tableView: UITableView = UITableView()
    
    let favViewModel = FavoriteListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.configureNavi()
        self.configureTableView()
        
        self.bindUI()
    }
    
    /// 네비게이션 셋팅
    private func configureNavi(){
        
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        self.title = self.favViewModel.naviTitle
        
        // Navi Left Button 추가 (닫기)
        let closeButton = UIBarButtonItem()
        closeButton.image = UIImage(systemName: "xmark")
        closeButton.tintColor = .black
        
        // 네비게이션 왼쪽 버튼 액션
        closeButton.rx.tap.subscribe(onNext: {
            // 닫아주기
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    
    /// 테이블뷰 셋팅
    private func configureTableView() {
        
        self.view.addSubview(self.tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        self.tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.identifier)
        
        self.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    private func bindUI() {
        
        // tableView data
        favViewModel.favList
            .bind(to: self.tableView.rx.items(cellIdentifier: MovieListCell.identifier,
                                              cellType: MovieListCell.self)) { row, movie, cell in
                
                cell.configureCell(with: movie)
            }.disposed(by: disposeBag)
        
        
        // tableview item 클릭 액션
        Observable
            .zip(self.tableView.rx.modelSelected(MovieViewModel.self),
                 self.tableView.rx.itemSelected)
            .subscribe(onNext: { [weak self] (movie, indexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: false)
                
                let detailVC = MovieDetailViewController(MovieDetailViewModel(infoVM: movie))
                
                self?.navigationController?.pushViewController(detailVC, animated: true)
                
            }).disposed(by: disposeBag)
        
    }
    
    
}


//MARK: - 테이블뷰 스크롤
extension FavoriteListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
