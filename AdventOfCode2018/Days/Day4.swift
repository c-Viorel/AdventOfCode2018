//
//  Day4.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 04/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day4 {
    
    let input:String = "4"
    
    func showSolutions() {
        let dataFromFile = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
        let solution = aAndB(dataFromFile)
        print("\tA: \(solution.a )")
        print("\tB: \(solution.b )")
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    func aAndB(_ dataIn:[(minute: Int, id: Int?, isSleep: Bool)]) -> (a:Int, b:Int) {
        var solution: (a:Int, b:Int) = (0,0)
        var guards: [Int: Int] = [:]
        var sleeping: [Int: [Int: Int]] = [:]
        var current = 0
        var startedSleeping = 0
        for event in dataIn {
            if let id = event.id {
                current = id
            }
            else if event.isSleep {
                startedSleeping = event.minute
            }
            else {
                for i in startedSleeping..<event.minute {
                    sleeping[current, default: [:]][i, default: 0] += 1
                }
                guards[current, default: 0] += (event.minute - startedSleeping)
            }
        }
        /* Part A */
        let sleepiest = guards.max(by: { $0.value < $1.value })!.key
         solution.a =  sleeping[sleepiest]!.max(by: { $0.value < $1.value })!.key * sleepiest
        
        /* Part B */
        let mostSleepyMinutes = sleeping.mapValues({ $0.max(by: { $0.value < $1.value })! })
        let mostSleep = mostSleepyMinutes.max(by: { $0.value.value < $1.value.value })!
        solution.b = mostSleep.key * mostSleep.value.key
        
        return solution
    }
    
    
   
    
    func getData() ->[(minute: Int, id: Int?, isSleep: Bool)] {
        var numbers:[(minute: Int, id: Int?, isSleep: Bool)] = []
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        if let url = resourceURL {
            do {
                let inputString = try String(contentsOf: url, encoding: .utf8)
                numbers = inputString.split(separator: "\n").sorted().map({ line -> (minute: Int, id: Int?, isSleep: Bool) in
                    let numbers = line.split(whereSeparator: { !"0123456789".contains($0) }).map { Int($0)! }
                    return (numbers[4], numbers.count > 5 ? numbers[5] : nil, line.contains("falls"))
                })

                
            } catch {
                print("Error at reading input file")
            }
        }
        return numbers
    }
    
    
}
