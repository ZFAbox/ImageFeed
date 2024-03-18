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
                    fulfillComplitionOnTheMainThread(.failure(error))
                }
                
                if let response = response as? HTTPURLResponse, 200 ..< 300 ~= response.statusCode {
                    fulfillComplitionOnTheMainThread(.failure(NetworkError.httpStatusCode(response.statusCode)))
                }
                
                if let data {
                    fulfillComplitionOnTheMainThread(.success(data))
                }
            }
            return task
    }
}
