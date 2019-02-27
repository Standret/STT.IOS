//
//  SttURLExtensions.swift
//  Lemon
//
//  Created by Peter Standret on 2/26/19.
//  Copyright © 2019 startupsoft. All rights reserved.
//

import Foundation

extension URL {
    subscript(queryParam: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}
