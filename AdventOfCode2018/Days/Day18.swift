//
//  Day18.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 18/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation

class Day18 {
    
    let inputFileName:String = "18"
    
    func showSolutions() {
        let str   = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(inputFileName):")
        
        let input = str.split(separator: "\n").map { line -> [Terrain] in
            return line.map { Terrain(rawValue: $0)! }
        }
        
        aOrB(input, target: 10, part: "A")
        aOrB(input, target: 1000000000, part: "B")
        
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    enum Terrain: Character {
        case open = ".", trees = "|", lumber = "#"
    }
    
    func aOrB(_ input: [[Terrain]], target: Int, part:String) {
        var area                         = input
        var currentTime                  = 0
        var previous: [[[Terrain]]: Int] = [area: 0]
        
        
        for _ in 0..<target {
            let next = (0..<area.count).map { y in
                return (0..<area.first!.count).map { x -> Terrain in
                    var trees = 0
                    var lumber = 0
                    for y2 in (y-1)...(y+1) {
                        for x2 in (x-1)...(x+1) {
                            switch area.get(y2)?.get(x2) ?? .open {
                            case .trees: trees += 1
                            case .lumber: lumber += 1
                            case .open: break
                            }
                        }
                    }
                    let current = area[y][x]
                    switch current {
                    case .open:
                        if trees >= 3 { return .trees }
                        else { return .open }
                    case .trees:
                        if lumber >= 3 { return .lumber }
                        else { return .trees }
                    case .lumber:
                        if lumber >= 2 && trees >= 1 { return .lumber }
                        else { return .open }
                    }
                }
            }
            area = next
            currentTime += 1
            if let existing = previous[area] {
                let difference = currentTime - existing
                let timeLeft   = target - existing
                let finalCycle = timeLeft % difference
                let newArea    = previous.filter({ $0.value == finalCycle + existing }).first!
                area           = newArea.key
                break
            }
            else {
                previous[area] = currentTime
            }
        }
        //area.map({ String($0.map { $0.rawValue }) }).joined(separator: "\n")
        let numberOfTrees   =      area.lazy.flatMap({ $0 }).filter({ $0 == .trees }).count
        let numberOfLumber  =    area.lazy.flatMap({ $0 }).filter({ $0 == .lumber }).count
        print("\t\(part): \(numberOfTrees * numberOfLumber)")
    }
    
    
    func getData() -> String {
        var data:String = ""
        let resourceURL = Bundle.main.url(forResource: inputFileName, withExtension: "txt")
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
