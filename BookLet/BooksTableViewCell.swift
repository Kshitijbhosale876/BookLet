//
//  BooksTableViewCell.swift
//  BookLet
//
//  Created by Kshitij Bhosale on 24/10/21.
//

import UIKit
class BooksTableViewCellViewModel {
    let book_name : String
    let subtitle : String
    let full_book_image : URL?
    var imageData : Data? = nil
    
    init(
        book_name: String,
        subtitle: String,
        full_book_image: URL?
    ) {
        self.book_name = book_name
        self.subtitle = subtitle
        self.full_book_image = full_book_image
    }
}

class BooksTableViewCell: UITableViewCell {

    static let identifier = "BooksTableViewCell"
    
    private let bookTitleLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 25, weight: .medium)
        return lable
    }()
    
    private let subtitleLable: UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 18, weight: .light)
        return lable
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bookTitleLable)
        contentView.addSubview(subtitleLable)
        contentView.addSubview(bookImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bookTitleLable.frame = CGRect (
            x: contentView.frame.size.width - 250,
            y: 0,
            width: contentView.frame.size.width - 250 ,
            height: 70
        )
        subtitleLable.frame = CGRect (
            x: contentView.frame.size.width - 250,
            y: 70,
            width: contentView.frame.size.width - 250 ,
            height: contentView.frame.size.height/2
        )
        bookImageView.frame = CGRect (
            x: 10,
            y: 5,
            width: 150 ,
            height: contentView.frame.size.height - 10 )
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        bookTitleLable.text = nil
        subtitleLable.text = nil
        bookImageView.image = nil
    }
    
    func configure(with viewModel: BooksTableViewCellViewModel){
        bookTitleLable.text = viewModel.book_name
        subtitleLable.text = viewModel.subtitle
        //Image
        if let data = viewModel.imageData{ //Change imageData to Full_book_image if image cannot be found and make the necessary changes in above class.
            bookImageView.image = UIImage(data: data)
            
        }
        else if let url = viewModel.full_book_image{
            //fetch images
            URLSession.shared.dataTask(with: url) { [weak self ]data, _, error  in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.bookImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
    }
    
}
