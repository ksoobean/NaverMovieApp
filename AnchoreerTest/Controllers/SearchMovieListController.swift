//
//  SearchMovieListController.swift
//  AnchoreerTest
//
//  Created by 김수빈 on 2022/05/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchMovieListController: UIViewController {
    
    private let tableView: UITableView = UITableView()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar { return searchController.searchBar }
    
    let listViewModel = MovieListViewModel()
    let disposeBag = DisposeBag()
    
    private var isLoadMore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.configureNavi()
        self.configureSearchBar()
        self.configureTableView()
        
        self.bindUI()
    }
    
    /// 네비게이션 셋팅
    private func configureNavi(){
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = self.listViewModel.naviTitle
        
    }
    
    /// Search Bar 셋팅
    private func configureSearchBar() {
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.text = ""
        searchBar.placeholder = listViewModel.placeHolderText
        self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
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
        
        // SearchBar Text
        searchBar.rx
            .searchButtonClicked
            .asObservable().map {
                self.searchBar.text
            }.subscribe(onNext: { [weak self] movie in
                if let movie = movie, !movie.isEmpty {
                    // 영화 검색하기
                    self?.requestMovieList(with: movie, loadMore: false)
                }
                // 키보드 종료
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        // tableView data
        listViewModel.movieList
            .bind(to: self.tableView.rx.items(cellIdentifier: MovieListCell.identifier,
                                                  cellType: MovieListCell.self)) { row, movie, cell in
                self.isLoadMore = false
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

//MARK: - 네트워크 통신
extension SearchMovieListController {
    
    private func requestMovieList(with movie: String = "", loadMore: Bool) {
        
        if !loadMore {
            // 더보기 조회X
            self.listViewModel.searchText.accept(movie)
        }
        
        self.isLoadMore = loadMore
        self.listViewModel.requestMovieList(isNew: !loadMore)
    }
    
    /// 테이블뷰 스크롤로 리스트 추가 조회 시 로딩뷰
    private func createLoadingView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}


//MARK: - 테이블뷰 스크롤
extension SearchMovieListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard self.isLoadMore != true else {
            return
        }
        
        let position = scrollView.contentOffset.y
        
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            guard self.listViewModel.hasMoreItemstoRequest else {
                // 모든 데이터 조회 완료 > 추가 데이터 조회 불가
                self.isLoadMore = false
                self.tableView.tableFooterView = nil
                return
            }
            
            self.tableView.tableFooterView = self.createLoadingView()
            self.requestMovieList(loadMore: true)
            
        }
    }
}
