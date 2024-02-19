//
//  String+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/19.
//

import Foundation

extension String {
   
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        return dateFormatter.date(from: self)
    }
    
}
