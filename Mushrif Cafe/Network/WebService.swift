//
//  NetworkHelper.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 09/10/24.
//

import UIKit

typealias Closure<T> = (T)->()
typealias JSON = [String: Any]

extension JSONDecoder {
    func decode<T : Decodable>(_ model : T.Type,
                               result : @escaping Closure<T>) ->Closure<Data> {
        return { data in
            if let value = try? self.decode(model.self, from: data){
                result(value)
            }
        }
    }
}

protocol APIResponseProtocol{
    func responseDecode<T: Decodable>(to modal : T.Type,
                              _ result : @escaping Closure<T>) -> APIResponseProtocol
    func responseJSON(_ result : @escaping Closure<JSON>) -> APIResponseProtocol
    func responseFailure(_ error :@escaping Closure<String>)
}
