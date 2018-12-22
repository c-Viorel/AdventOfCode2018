//
//  Day14.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 14/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day14 {
    
    let input:String = "14"
    
    func showSolutions(inputValue: Int = 330121 ) {
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
        print("\tA: \(a(inputValue) )")
        print("\tB: \(b(inputValue) )")
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    func a(_ input: Int) -> String {
        var recipes = [3, 7]
        var elves = [0, 1]
        while recipes.count < (input + 10) {
            let score = elves.lazy.map({ recipes[$0] }).reduce(0, +)
            if score >= 10 {
                recipes.append(score / 10 % 10)
            }
            recipes.append(score % 10)
            elves = elves.map { ($0 + recipes[$0] + 1) % recipes.count }
        }
        
        return recipes[input...].prefix(10).map(String.init).joined()
    }
    
    func b(_ input: Int) -> Int{
        var target = [Int]()
        var tmp = input
        while tmp > 0 {
            target.insert(tmp % 10, at: 0)
            tmp /= 10
        }
        var recipes = [3, 7]
        var elves = [0, 1]
        while recipes.suffix(target.count) != target[...] && recipes.dropLast().suffix(target.count) != target[...] {
            let score = elves.lazy.map({ recipes[$0] }).reduce(0, +)
            if score >= 10 {
                recipes.append(score / 10 % 10)
            }
            recipes.append(score % 10)
            elves = elves.map { ($0 + recipes[$0] + 1) % recipes.count }
        }
        if recipes.suffix(target.count) == target[...] {
            return recipes.count - target.count
        }
        else {
            return recipes.count - target.count - 1
        }
    }
}
