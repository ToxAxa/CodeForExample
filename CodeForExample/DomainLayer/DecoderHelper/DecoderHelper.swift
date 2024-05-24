//
//  DecoderHelper.swift
//  CodeForExample
//
//  Created by Anton Korchevskyi on 26.04.2024.
//

import Alamofire

enum DecodicError: Error {
    case dataIsNil
    case decodeError
    case error(Error)
}

final class DecoderHelper {
    static func decode<T: Codable>(result: DataResponse<Any, AFError>, model: T.Type) -> T? {
        guard let data = result.data else { return nil }
        do {
            let propertiesModel = try JSONDecoder().decode(DataWrapper<T>.self, from: data)
            return propertiesModel.data
        } catch let error {
            print(String(describing: error))
            LOG.error("Data decode \(T.Type.self) model")
            LOG.error(error.localizedDescription)
            return nil
        }
    }
    
    static func decode<S: Codable>(data: Data?, model: S.Type) -> S? {
        guard let data = data else {
            LOG.error("Data model \(S.Type.self) is nil")
            return nil
        }
        
        do {
            let model = try JSONDecoder().decode(model.self, from: data)
            return model
        } catch let error {
            LOG.error("Data decode \(S.Type.self) model")
            LOG.error(error.localizedDescription.debugDescription)
            return nil
        }
    }
    
    static func decodeErrors<S: Codable>(data: Data?, model: S.Type) -> Result<S, DecodicError> {
        guard let data = data else {
            LOG.error("Data model \(S.Type.self) is nil")
            return .failure(.dataIsNil)
        }
        
        do {
            let model = try JSONDecoder().decode(S.self, from: data)
            return .success(model)
        } catch let error {
            return .failure(.error(error))
        }
    }
    
    static func decodeErrors<T: Codable>(result: DataResponse<Any, AFError>, model: T.Type) -> T? {
        guard let data = result.data else { return nil }
        do {
            let propertiesModel = try JSONDecoder().decode(ErrorsWrapper<T>.self, from: data)
            return propertiesModel.errors
        } catch let error {
            LOG.error("Data decode \(T.Type.self) model")
            LOG.error(error.localizedDescription)
            return nil
        }
    }
}
