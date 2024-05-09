//
//  MainPageViewController.swift
//  BookSearching
//
//  Created by 이유진 on 5/1/24.
//

import UIKit
import SnapKit
import Kingfisher

class MainPageViewController: UIViewController {
    
    let topCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let bottomCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let topCollectionViewCell = TopCollectionViewCell()
    let bottomColletctionViewCell = BottomCollectionViewCell()
    
    var bookData: [Document] = []
    var selectedBookDatas: [Document] = []
    var selectedBookData: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        [topCollectionView, bottomCollectionView].forEach {
            view.addSubview($0)
        }
        
        setupSearchBarUI()
        setupSubtitleLabels()
        setupCollectionView()
        
    }
    
}

//MARK: - SearchBar UI
extension MainPageViewController: UISearchBarDelegate {
    
    func setupSearchBarUI() {
        
        let searchBar: UISearchBar = {
            
            let searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.backgroundImage = UIImage()
            searchBar.searchTextField.backgroundColor = UIColor.white
            searchBar.layer.cornerRadius = 20
            searchBar.layer.masksToBounds = true
            searchBar.layer.shadowColor = UIColor.black.cgColor
            searchBar.layer.shadowOffset = CGSize(width: 2, height: 2)
            searchBar.layer.shadowOpacity = 0.1
            searchBar.layer.shadowRadius = 2
            
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.leftView = nil
                textField.layer.cornerRadius = 20
                textField.clipsToBounds = true
                
                textField.leftViewMode = .always
                textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textField.frame.height))
            }
            
            let iconImageView = UIImageView(image: UIImage(named: "search_icon"))
            iconImageView.contentMode = .scaleAspectFit
            searchBar.addSubview(iconImageView)
            
            iconImageView.snp.makeConstraints { make in
                make.top.equalTo(searchBar.snp.top).offset(23)
                make.leading.equalTo(searchBar.snp.leading).offset(23)
            }
            
            return searchBar
        }()
        
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(95)
            make.leading.equalToSuperview().offset(27.5)
            make.trailing.equalToSuperview().inset(27.5)
            make.height.equalTo(60)
        }
    }
    
}

// MARK: - subtitleLabels UI
extension MainPageViewController {
    
    private func setupSubtitleLabels() {
        let recentBook: UILabel = {
            let label = UILabel()
            label.text = "최근 본 책"
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.textColor = UIColor.myBlack
            return label
        }()
        
        let searchResult: UILabel = {
            let label = UILabel ()
            label.text = "검색 결과"
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            label.textColor = UIColor.myBlack
            return label
        }()
        
        [recentBook, searchResult].forEach {
            view.addSubview($0)
        }
        
        recentBook.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(178)
            make.leading.equalToSuperview().offset(29)
        }
        
        searchResult.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(427)
            make.leading.equalToSuperview().offset(29)
        }
    }
}


//MARK: - CollectionView UI
extension MainPageViewController {
    private func setupCollectionView() {
        configureTopCollectionView()
        configureBottomCollectionView()
    }
    
    private func configureTopCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 124, height: 182)
        layout.minimumLineSpacing = 25
        layout.scrollDirection = .horizontal
        
        topCollectionView.setCollectionViewLayout(layout, animated: false)
        
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        topCollectionView.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: TopCollectionViewCell.identifier)
        topCollectionView.isScrollEnabled = true
        topCollectionView.showsHorizontalScrollIndicator = false
        
        topCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(205)
            make.leading.equalToSuperview().offset(27.5)
            make.size.equalTo(CGSize(width: 393, height: 182))
        }
        
    }
    
    private func configureBottomCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 124, height: 182)
        layout.minimumLineSpacing = 25
        layout.scrollDirection = .horizontal
        
        bottomCollectionView.setCollectionViewLayout(layout, animated: false)
        
        bottomCollectionView.delegate = self
        bottomCollectionView.dataSource = self
        bottomCollectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        bottomCollectionView.isScrollEnabled = true
        bottomCollectionView.showsHorizontalScrollIndicator = false
        
        bottomCollectionView.snp.makeConstraints { make in
            make.top.equalTo(topCollectionView.snp.bottom).offset(67)
            make.leading.equalToSuperview().offset(27.5)
            make.size.equalTo(CGSize(width: 393, height: 230))
        }
    }
    
}

// MARK: - CollectionView UI (Delegate, DataSource, FlowLayout)
extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topCollectionView {
            return selectedBookDatas.count
        } else {
            return bookData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bottomCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as! BottomCollectionViewCell
            
            let bookData = bookData[indexPath.item]
            cell.titleLabel.text = bookData.title
            cell.priceLabel.text = "\(bookData.price)\("원")"
            cell.authorLabel.text = bookData.authors.joined(separator: ", ")
            
            if let url = URL(string: bookData.thumbnail) {
                cell.bottomImageView.kf.setImage(with: url)
            }
            
            
            print("bottom update")
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCollectionViewCell.identifier, for: indexPath) as! TopCollectionViewCell
            
            let selectedBookData = selectedBookDatas[indexPath.row]
            
            if let url = URL(string: selectedBookData.thumbnail) {
                print("Loading image from URL: \(url)")
                cell.topImageView.kf.setImage(with: url, completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Image successfully loaded: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Error loading image: \(error.localizedDescription)")
                    }
                })
            } else {
                print("Invalid URL: \(selectedBookData.thumbnail)")
            }            //print("top update")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCollectionView {
            tabBarController?.selectedIndex = 2
        } else {
            if let bookInfoPage = tabBarController?.viewControllers?[2] as? BookInfoPageViewController {
                
                selectedBookData = bookData[indexPath.item]
                bookInfoPage.bookData = selectedBookData
                selectedBookDatas.append(selectedBookData!)
                topCollectionView.reloadData()
                
                
                //              print(selectedBookData)
                tabBarController?.selectedIndex = 2
                navigationController?.pushViewController(bookInfoPage, animated: true)
            }
        }
        
    }
}

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCollectionView {
            let width: CGFloat = 123
            let height: CGFloat = 182
            return CGSize(width: width, height: height)
        } else {
            let width: CGFloat = 123
            let height: CGFloat = 230
            return CGSize(width: width, height: height)
        }
    }
}

// MARK: - Data Networking

extension MainPageViewController {
    
    func fetchBookData(query: String?) {
        NetworkManager.shared.fetchBookAPI(query: query ?? "") { result in
            switch result {
            case .success(let bookData):
                self.bookData = bookData.documents
                print("Book Data:", self.bookData as Any)
                
                for document in bookData.documents {
                    print(document.title)
                    print(document.price)
                    print(document.authors)
                    print(document.thumbnail)
                }
                
                DispatchQueue.main.async {
                    self.bottomCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
    
}

// MARK: - 검색어 전달
extension MainPageViewController {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchBookData(query: searchBar.text)
        searchBar.resignFirstResponder()
        print("text")
    }
}
