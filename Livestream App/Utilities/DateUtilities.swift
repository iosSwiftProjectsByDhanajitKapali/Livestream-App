//
//  DateUtilities.swift
//  daffo-ios-base
//
//  Created by Sujeet Shrivastav on 14/08/20.
//  Copyright © 2020 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

struct DateUtility {

    public func stringToDate(dateInString : String, toFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat.rawValue
        
        return dateFormatter.date(from: dateInString)
    }
    
    public func dateToString(date: Date, toFormat: DateFormat) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat.rawValue
        return dateFormatter.string(from: date)
    }

}

enum DateFormat: String {
    
    ///Format Example : 29/07/2021
    case ddMMyySeparatorSlash = "dd/MM/yy"
    
    ///Format Example : 29.07.2021
    case ddMMyySeparatorDot = "dd.MM.yy"
    
    ///Format Example : 28.10.1980
    case ddmmyyyySeparatorDot = "dd.mm.yyyy"
    
    ///Format Example : 28,10,90
    case ddMMyySeparatorComma = "dd,MM,yy"
    
    ///Format Example : 28-OCT-90
    case ddmmmyySeparatorDash = "dd-mmm-yy"
    
    ///Format Example : 28-OCT-1990
    case ddmmmyyyySeparatorDash = "dd-mmm-yyyy"
    
    ///Format Example : 10/28/90
    case mmddyySeparatorSlash = "mm/dd/yy"
    
    ///Format Example : 10/28/1990
    case mmddyyyySeparatorSlash = "mm/dd/yyyy"
    
    ///Format Example : 90/10/28
    case yymmddSeparatorSlash = "yy/mm/dd"
    
    ///Format Example : 1980/10/28
    case yyyymmddSeparatorSlash = "yyyy/mm/dd"
    
    ///Format Example : 4 Q 90
    case qQyySeparatorSpace = "q Q yy"
    
    ///Format Example : Q 1980
    case qQyyyySeparatorSapce = "q Q yyyy"
    
    ///Format Example : OCT 90
    case mmmyySeparatorSpace = "mmm yy"
    
    ///Format Example : OCT 1990
    case mmmyyyySeparatorSpace = "mmm yyyy"
    
    ///Format Example : 43 WK 90
    case wwWKyySeparatorSpace = "ww WK yy"
    
    ///Format Example : 43 WK 1990
    case wwWKyyyySeparatorSpace = "ww WK yyyy"
    
    ///Format Example : 01:02
    case hhmmSeparatorColon = "hh:mm"
    
    ///Format Example : 01:02:34.75
    case hhmmsssSeparatorColon = "hh:mm:ss.s"
    
    ///Format Example : 20 08:03
    case ddhhmmSeparatorSpaceColon = "dd hh:mm"
    
    ///Format Example : 20 08:03:00
    case ddhhmmsssSeparatorSpaceColon = "dd hh:mm:ss.s"
    
    ///Format Example : 20-JUN-1990 08:03
    case ddmmmyyyyhhmmSeparatorDashSpaceColon = "dd-mmm-yyyy hh:mm"
    
    ///Format Example : 20-JUN-1990 08:03:00
    case ddmmmyyyyhhmmsssSeparatorDashSpaceColon = "dd-mmm-yyyy hh:mm:ss.s"
}

