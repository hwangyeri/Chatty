//
//  Date+.swift
//  Chatty
//
//  Created by Yeri Hwang on 2024/02/15.
//

import Foundation

extension Date {
    
    static func DTFormatter(_ dateString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: dateString) {
            let myDateFormatter = DateFormatter()
            myDateFormatter.dateFormat = "h:mm a"
            myDateFormatter.timeZone = TimeZone(identifier: "UTC") 
            
            return myDateFormatter.string(from: date)
        }
        
        return nil
    }
    
    
}
