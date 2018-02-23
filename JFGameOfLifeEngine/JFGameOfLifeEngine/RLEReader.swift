//
//  RLEReader.swift
//  JFGameOfLifeEngine
//
//  Created by John Fisher on 2/14/15.
//  Copyright (c) 2015 John Fisher. All rights reserved.
//

import Foundation


open class RLEReader<MatrixType: Matrix> {
    public init() {}
    
    open func buildBoard(_ file: String) -> GameBoard<MatrixType>? {
        guard let fileURL = Bundle.main.url(forResource: file, withExtension: "lif") else {
            // File not found
            return nil
        }
        
        guard let fileString = try? String(contentsOf: fileURL, encoding: .utf8) else {
            // Unable to read file as string
            return nil
        }
        
        guard let range = fileString.range(of:"\\n[ob0-9!$]", options: .regularExpression) else {
            // Unable to find start of encoding
            return nil
        }
        
        let rleEncoding = fileString.substring(from: range.lowerBound).replacingOccurrences(of: "\n", with: "")
        let matrix = parseBoard(rleEncoding: rleEncoding)
        
        return GameBoard<MatrixType>(matrix: matrix, aliveRuleSet: ConwaysRules.aliveRuleset, deadRuleSet: ConwaysRules.deadRuleset)
    }
    
    func parseBoard(rleEncoding: String) -> MatrixType {
        let matrix = MatrixType()
        var currentRow = 0, currentColumn = 0
        for runCount in matches(for: "([ob]|\\d+[ob]|\\d+\\$|\\$)", in: rleEncoding) {
            print("\(runCount.1.location), \(runCount.1.length): \(runCount.0)")
            
            if let repeatRange = runCount.0.range(of:"\\d+", options: .regularExpression) {
                // Repeated o, b or $
                let indexRepeatStart = repeatRange.lowerBound
                let indexRepeatEnd   = repeatRange.upperBound
                
                let repeatStr = runCount.0[indexRepeatStart..<indexRepeatEnd]
                let cellValue = String(runCount.0[indexRepeatEnd...])
                
                if let numRepeats = Int(repeatStr) {
                    print("pulled repeats: \(numRepeats)")
                    if cellValue == "$" {
                        currentRow   += 1
                        currentColumn = 0
                    } else {
                        for _ in 0 ..< numRepeats {
                            addCell(column: currentColumn, row: currentRow, withType: cellValue, toMatrix: matrix)
                            currentColumn += 1
                        }
                    }
                }
            } else {
                // lone $, b or o
                let cellValue = runCount.0
                if cellValue == "$" {
                    currentRow   += 1
                    currentColumn = 0
                } else {
                    addCell(column: currentColumn, row: currentRow, withType: cellValue, toMatrix: matrix)
                    currentColumn += 1
                }
            }
        }
        
        return matrix
    }
    
    func addCell(column: Int, row: Int, withType: String, toMatrix: MatrixType) {
        if withType == "o" {
            toMatrix[column, row] = Cell(state: CellState.alive)
        } else {
            toMatrix[column, row] = Cell(state: CellState.dead)
        }
    }
    
    func matches(for regex: String, in text: String) -> [(String, NSRange)] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { (nsString.substring(with: $0.range), $0.range) }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
