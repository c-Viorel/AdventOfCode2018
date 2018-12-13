//
//  Day5.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 05/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day5 {
    
    let input:String = "5"
    
    func showSolutions() {
        let dataFromFile = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
        print("\tA: \(a(dataFromFile) )")
        print("\tB: \(b(dataFromFile) )")
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    func a(_ dataIn:String) -> Int {
        var chars = ""
        for char in dataIn {
            guard let prev = chars.last else { chars.append(char); continue }
            if String(prev).lowercased() == String(char).lowercased() && prev != char {
                _ = chars.popLast()
            }
            else {
                chars.append(char)
            }
        }
        
        return chars.count - 1 
    }
    
    func b(_ dataIn:String) -> Int  {
        let lengths = Set(dataIn.lazy.map { String($0).lowercased() }).map { letter -> Int in
            var chars = ""
            for char in dataIn {
                guard String(char).lowercased() != letter else { continue }
                guard let prev = chars.last else { chars.append(char); continue }
                if String(prev).lowercased() == String(char).lowercased() && prev != char {
                    _ = chars.popLast()
                }
                else {
                    chars.append(char)
                }
            }
            return chars.count - 1
        }
        return lengths.min()!
    }
    
    func getData() ->String {
        var data:String = ""
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        if let url = resourceURL {
            do {
                data = try String(contentsOf: url, encoding: .utf8)
              
            } catch {
                print("Error at reading input file")
            }
        }
        return data
    }
    
    
}
