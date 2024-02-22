//
//  Date+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/15.
//

import Foundation

extension Date {
    
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "ko-KR")
        
        return dateFormatter.string(from: self)
    }
    
    func toStringMy() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter.string(from: self)
    }
    
    func formattedSideDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy. MM. dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
       
        return dateFormatter.string(from: self)
    }
    
}
