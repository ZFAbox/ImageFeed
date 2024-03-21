//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 10.03.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data (
        for request: URLRequest,
        complition: @escaping (Result<Data, Error>) ->Void) -> URLSessionTask {
            let fulfillComplitionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    complition(result)
                }
            }
            
            let task = dataTask(with: request) { data, response, error in
                if let error {
                    fulfillComplitionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfillComplitionOnTheMainThread( .failure(NetworkError.urlSessionError))
                }
                
                if let data = data, let response = response, let statusCode = (response  as? HTTPURLResponse)?.statusCode {
                    if 200 ..< 300 ~= statusCode {
                        fulfillComplitionOnTheMainThread(.success(data))
                    } else {
                        fulfillComplitionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                }
            }
            return task
    }
}
