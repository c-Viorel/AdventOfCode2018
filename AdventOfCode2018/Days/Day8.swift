//
//  Day8.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 08/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation
class Day8 {
    
    let input:String = "8"
    
    func showSolutions() {
        let dataFromFile = getData()
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
        let solution = aAndB(dataFromFile)
        print("\tA: \(solution.a)")
        print("\tB: \(solution.b )")
        
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    
    func aAndB(_ dataIn:[Int]) -> (a:Int, b:Int) {
        var solution:(a:Int, b:Int)
        var iter = dataIn.makeIterator()
        var step = 0 ;
        func readNode() -> Node {
            let numChildren = iter.next()!
            let numMetadata = iter.next()!
            let children = (0..<numChildren).map { _ in readNode() }
            let metadata = (0..<numMetadata).map { _ in iter.next()! }
            return Node(children: children, metadata: metadata)
        }
        let tree = readNode()
        // Part A
        solution.a = tree.sumMetadata()
        // Part B
        solution.b =  tree.value()
        
        
        return solution
    }
    
   
    struct Node {
        var children: [Node]
        var metadata: [Int]
        func sumMetadata() -> Int {
            return metadata.reduce(0, +) + children.lazy.map({
                $0.sumMetadata()}).reduce(0, +)
        }
        func value() -> Int {
            if children.isEmpty {
                return sumMetadata()
            }
            return metadata.map({ $0 > children.count ? 0 : children[$0 - 1].value() }).reduce(0, +)
        }
    }
    
    
    func getData() ->[Int] {
        var numbers:[Int] = []
        let resourceURL = Bundle.main.url(forResource: input, withExtension: "in")
        if let url = resourceURL {
            do {
                let inputString = try String(contentsOf: url, encoding: .utf8)
                inputString.split(separator: " ").forEach { (nString) in
                    if let n = Int(nString) {numbers.append(n)}
                }
            } catch {
                print("Error at reading input file")
            }
        }
        return numbers
    }
    
}
