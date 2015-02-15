//
//  String+Regex.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/14/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation

extension String {
    func exec (str: String) -> Array<(NSRange, String)> {
        var err : NSError?
        if let regex = NSRegularExpression(pattern: self, options: NSRegularExpressionOptions(0), error: &err) {
            let nsstr = str as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : Array<(NSRange, String)> = Array<(NSRange, String)>()
            regex.enumerateMatchesInString(str, options: NSMatchingOptions(0), range: all) {
                (result : NSTextCheckingResult!, _, _) in
                matches += [(range: result.range, result: nsstr.substringWithRange(result.range))]
            }
            return matches
        }
        else {
            return Array<(NSRange, String)>()
        }
    }
    
    func firstMatch (str: String) -> (NSRange, String)? {
        var err : NSError?
        if let regex = NSRegularExpression(pattern: self, options: NSRegularExpressionOptions(0), error: &err) {
            let nsstr = str as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            
            if let match = regex.firstMatchInString(nsstr, options: nil, range: NSRange(location: 0, length: nsstr.length)) {
                let matchStr = (str as NSString).substringWithRange(match.range) as String
                return (match.range, matchStr)
            }
        }
        
        return nil
    }
}