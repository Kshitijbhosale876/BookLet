//
//  APICaller.swift
//  BookLet
//
//  Created by Kshitij Bhosale on 23/10/21.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    struct Constants {
        static let bookNameURLsv =  URL(string: "http://13.235.223.51/bookletapp/public/api/test_api/get-all-books") //add a s after http if the connect is not secure
    }
    
    private init() {
    }
    
    public func getTopBooks(completion: @escaping (Result<[Book],Error>) -> Void ) {
        guard let url = Constants.bookNameURLsv else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if data == data {
                do {
                    let result = try JSONDecoder().decode(APIRespone.self, from: data!)
                    print("Books\(result.books.count)")
                    completion(.success(result.books))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}

//Models

struct APIRespone : Codable {
    let books : [Book]
}

struct Book : Codable {
    
    let book_name : String
    let book_image : String
    let subtitle : String
    let full_book_image : URL 
}
