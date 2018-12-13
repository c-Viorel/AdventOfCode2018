//
//  Day7.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 07/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day7 {
    
    let input:String = "7"
    
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
    
    
    func a(_ dataIn:[(finish:String,start:String)]) -> String {
        var prereqs = [String: Set<String>]()
        var all: Set<String> = []
        for (from, to) in dataIn {
            prereqs[to, default: []].insert(from)
            all.insert(from)
            all.insert(to)
        }
        var available: [String] = all.filter({ !prereqs.keys.contains($0) })
        available.sort(by: { $0 > $1 })
        var order: [String] = []
        while let node = available.popLast() {
            order.append(node)
            for thing in prereqs.keys {
                prereqs[thing]!.remove(node)
                if prereqs[thing]!.isEmpty {
                    prereqs[thing] = nil
                    available.append(thing)
                }
            }
            available.sort(by: { $0 > $1 })
        }
        return order.joined().uppercased()
        
    }
    
    func b(_ dataIn:[(finish:String,start:String)]) -> Int  {
        var prereqs = [String: Set<String>]()
        var all: Set<String> = []
        for (from, to) in dataIn {
            prereqs[to, default: []].insert(from)
            all.insert(from)
            all.insert(to)
        }
        var available: [String] = all.filter({ !prereqs.keys.contains($0) })
        available.sort(by: { $0 > $1 })
        func finish(_ node: String) {
            for thing in prereqs.keys {
                prereqs[thing]!.remove(node)
                if prereqs[thing]!.isEmpty {
                    prereqs[thing] = nil
                    available.append(thing)
                }
            }
            available.sort(by: { $0 > $1 })
        }
        func timeOf(_ str: String) -> Int {
            return 61 + Int(str.utf8.first! - UInt8(ascii: "a"))
        }
        var workers = [(Int, String)](repeating: (0, ""), count: 5)
        var time = 0
        while true {
            for index in workers.indices {
                workers[index].0 -= 1
                if workers[index].0 <= 0 {
                    if workers[index].1 != "" {
                        finish(workers[index].1)
                        workers[index].1 = ""
                    }
                }
            }
            for index in workers.indices where workers[index].0 <= 0 {
                if let next = available.popLast() {
                    workers[index] = (timeOf(next), next)
                }
            }
            if !workers.contains(where: { $0.0 > 0 }) { break }
            time += 1
        }
        return time
    }
    
    func getData() ->[(finish:String,start:String)] {
        var souce:[(finish:String,start:String)] = []
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        if let url = resourceURL {
            do {
                let inputString = try String(contentsOf: url, encoding: .utf8).split(separator: "\n")
                for item in inputString  {
                    souce.append((finish: "\(item[5])".lowercased(), start: "\(item[36])".lowercased()))
                }
            } catch {
                print("Error at reading input file")
            }
        }
        return souce
    }
    
    
}
