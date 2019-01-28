//
//  SttDataExtensions.swift
//  Lemon
//
//  Created by Piter Standret on 1/22/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

extension Data {
    
    func getObject<TResult: Decodable>(of _: TResult.Type) -> TResult? {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .customISO8601
            return try decoder.decode(TResult.self, from: self)
        }
        catch {
            return nil
        }
    }
}
