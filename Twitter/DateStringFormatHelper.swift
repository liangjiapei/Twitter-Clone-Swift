//
//  DateStringFormatHelper.swift
//  Twitter
//
//  Created by Jiapei Liang on 2/26/17.
//  Copyright © 2017 jiapei. All rights reserved.
//

import UIKit

class DateStringFormatHelper: NSObject {

    static func getTimeSinceNow(dateStr: String) -> String {
        
        let ONE_MINUTE_TIMESTAMP = 60.0
        let ONE_HOUR_TIMESTAMP = 60.0 * 60
        let ONE_DAY_TIMESTAMP = 60.0 * 60 * 24
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        print("dateStr: \(dateStr)")
        
        let date = dateFormatter.date(from: dateStr)
        
        let currentTimeStamp = Date().timeIntervalSince1970
        
        let timestamp = (date?.timeIntervalSince1970)!
        
        let timeDiffSinceNow = Double(currentTimeStamp - timestamp)
        
        if timeDiffSinceNow < ONE_HOUR_TIMESTAMP {
            
            let timeDiffSinceNowInMinute = Int(round(timeDiffSinceNow / ONE_MINUTE_TIMESTAMP))
            
            return "\(timeDiffSinceNowInMinute)m"
            
        } else if timeDiffSinceNow > ONE_HOUR_TIMESTAMP && timeDiffSinceNow < ONE_DAY_TIMESTAMP  {
            
            let timeDiffSinceNowInHour = Int(round(Double(timeDiffSinceNow / ONE_HOUR_TIMESTAMP)))
            
            return "\(timeDiffSinceNowInHour)h"
            
        } else if (timeDiffSinceNow > ONE_DAY_TIMESTAMP) {
            
            let timeDiffSinceNowInDay = Int(round(Double(timeDiffSinceNow / ONE_DAY_TIMESTAMP)))
            
            return "\(timeDiffSinceNowInDay)h"
            
        } else {
            return "nil"
        }
        
    }
    
}
