//
//  CurrencyDataRequest.swift
//  CurrencyConverter
//
//  Created by mani on 2020-09-22.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

enum Result<Value, Error: Swift.Error> {
    case success(Value),
    failure(Error)
}

class CurrencyDataRequest {
    private let url: URL
    private let session: URLSessionProtocol
    private var dataTask: URLSessionDataTask?

    init(url: URL, session: URLSessionProtocol = URLSession.shared) {
        self.url = url
        self.session = session
    }

    func getData(completion: @escaping (Result<Data, Error>) -> ()) {
        dataTask?.cancel()

        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                completion(.success(data))
                self?.dataTask = nil
            } else if let error = error {
                completion(.failure(error))
            }
        }

        self.dataTask = task
        task.resume()
    }
}
