//
//  ViewController.swift
//  BookLet
//
//  Created by Kshitij Bhosale on 23/10/21.
//

import UIKit
//TableView
//CustomCell
//API caller
//Open the TineyBook

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    private var viewModels = [BooksTableViewCellViewModel]()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BooksTableViewCell.identifier , for: indexPath) as? BooksTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    private let tableView : UITableView = {
        let table = UITableView()
        table.register(BooksTableViewCell.self, forCellReuseIdentifier: BooksTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "BookLet"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        APICaller.shared.getTopBooks { [weak self] result in //[weak self]
            switch result {
            case .success(let books):
                self?.viewModels = books.compactMap({
                    BooksTableViewCellViewModel(book_name: $0.book_name, subtitle: $0.subtitle, full_book_image: $0.full_book_image)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure (let error):
                print(error)
            
        }
            
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}


