//
//  StringExtension.swift
//  daffo-ios-base
//
//  Created by unthinkable-mac-0025 on 30/07/21.
//  Copyright © 2021 Daffodil Software Pvt. Ltd. All rights reserved.
//

import Foundation

extension String {
    var isAlphanumericWithNoSpaces: Bool {
        let alphaNumSet = CharacterSet(
            charactersIn: Constant.RegexExplression.ALL_CASE_ALPHABETS_AND_NUMBERS
        )
        return rangeOfCharacter(from: alphaNumSet.inverted) == nil
    }
    
    var hasNumbers: Bool {
        return rangeOfCharacter(from: CharacterSet(charactersIn: Constant.RegexExplression.WHOLE_NUMBERS)) != nil
    }
    
    var validFilename: String {
        guard !isEmpty else { return Constant.TextMessage.EMPTY_FILE_NAME }
        return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? Constant.TextMessage.EMPTY_FILE_NAME
    }
    
    func isValidMobileNo() -> Bool {
        let PHONE_REGEX = "(0|91)?[7-9][0-9]{9}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: self)
        return result
    }
    
    //Regex fulfill RFC 5322 Internet Message format
    func isEmailFormatted() -> Bool {
        let emailRegex = Constant.RegexExplression.EMAIL_REGEX
        let predicate = NSPredicate(format: Constant.Predicates.SELF_MATCHES__, emailRegex)
        return predicate.evaluate(with: self)
    }
}

extension Optional where Wrapped == String{
    
    func isEmptyOrWhitespace() -> Bool {
        // Check nil
        let theString = self
        guard let this = theString else { return true }
        
        // Check empty string
        if this.isEmpty {
            return true
        }
        // Trim and check empty string
        let isEmpty = this.trimmingCharacters(in: .whitespaces) == ""
        return isEmpty
    }
}
    
