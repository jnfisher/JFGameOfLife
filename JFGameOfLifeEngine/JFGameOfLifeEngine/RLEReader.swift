//
//  RLEReader.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/14/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation


public class RLEReader {
    public init() {}
    
    public func buildBoard<MatrixType: Matrix>(file: NSString) -> GameBoard<MatrixType>? {
        var bundle = NSBundle.mainBundle()
        var matrix = MatrixType()
        
        if let fileName = bundle.pathForResource(file, ofType: "lif") {
            var error: NSError?
            if let fileContents = NSString(contentsOfFile: fileName, encoding: NSUTF8StringEncoding, error: &error) {
                var fileString = fileContents as String
                if let rng = "\\n[ob0-9!$]".firstMatch(fileString) {
                    let si = advance(fileString.startIndex, rng.0.location)
                    fileString = fileString.substringWithRange(Range<String.Index>(start: si, end: fileString.endIndex))
                }
                else {
                    return nil
                }
                
                let encoding = fileString.stringByReplacingOccurrencesOfString("\n", withString: "")
                let rowEncodings = encoding.componentsSeparatedByString("$")
                for (currentRow, rowEncoding) in enumerate(rowEncodings) {
//                    print(rowEncoding + ":")

                    var repeats = "\\d+".exec(rowEncoding)
                    if repeats.count == 0 || repeats[0].0.location > 0 {
                        repeats = [(NSRange(location: 0, length: 0), "1")] + repeats
                    }
                    
                    var currentColumn = 0
                    for (index, repeat) in enumerate(repeats) {
                        var repeatCount = repeat.1.toInt()!
//                        print("\(repeatCount)-")
                        
                        let substringStartIndex = advance(rowEncoding.startIndex, repeat.0.location+repeat.0.length)
                        let substringEndIndex = (index == repeats.count-1) ?
                                rowEncoding.endIndex :
                                advance(rowEncoding.startIndex, repeats[index+1].0.location)
                        let cells = rowEncoding.substringWithRange(
                            Range<String.Index>(start: substringStartIndex, end: substringEndIndex))
                        
//                        print(cells + ", ")
                        for (charIndex, char) in enumerate(cells) {
                            if charIndex == 0 {
                                if char == "b" {
                                    currentColumn += repeatCount
                                }
                                else if char == "o" {
                                    for i in 0..<repeatCount {
//                                        print("(\(currentRow), \(currentColumn)) ")
                                        matrix[currentColumn++, currentRow] = Cell(state: CellState.Alive)
                                    }
                                }
                                
                                continue
                            }
                            else {
                                if char == "o" {
//                                    print("(\(currentRow), \(currentColumn)) ")
                                    matrix[currentColumn++, currentRow] = Cell(state: CellState.Alive)
                                }
                                else if char == "b" {
                                    currentColumn++
                                }
                            }
                        }
                        
                        
                    }
//                    println()
                }
            }
            else if error != nil {
                println(error.debugDescription)
                return nil
            }
            
            return GameBoard<MatrixType>(matrix: matrix, aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset)
        }
        
        
        return nil
    }
}