//
//  Day9.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 09/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Foundation

class Day9 {
    
    let input:String = "9"
    
    //412 players; last marble is worth 71646 points
    func showSolutions(numberOfPlayers:Int = 441, highestScore:Int = 71032) {
        let date1 = Date()
        print("─────────────────────────────────────────")
        print("Day \(input):")
        print("\tA: \(aAndB(players: numberOfPlayers, last: highestScore))")
        print("\tB: \(aAndB(players: numberOfPlayers, last: highestScore * 100 ) )")

        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed in \(String.init(format: "%.6f", run)) sec.")
        }
    }
    
    

    
    func aAndB(players: Int, last: Int) -> Int {
        var scores       = Array(repeating: 0, count: players)
        var cirulatList  = Node(0, next: nil, prev: nil)
        cirulatList.next = cirulatList
        cirulatList.prev = cirulatList
        var currentTurn = 0
        for i in 1..<last {
            defer {
                currentTurn += 1
                if currentTurn == scores.count { currentTurn = 0 }
            }
            if i % 23 == 0 {
                scores[currentTurn] += i
                for _ in 0..<6 {
                    cirulatList = cirulatList.prev
                }
                scores[currentTurn] += cirulatList.removePrev()
            }
            else {
                cirulatList = cirulatList.next
                cirulatList = cirulatList.insertNext(value: i)
            }
        }

//        while cirulatList.next != nil {
//            let prev = cirulatList
//            cirulatList    = cirulatList.next
//            prev.next = nil
//        }
        
        return scores.max() ?? -1
    }
    
    class Node {
        let value: Int
        var next: Node!
        weak var prev: Node!
        init(_ value: Int, next: Node?, prev: Node?) {
            self.value = value
            self.next = next
            self.prev = prev
        }
         func insertNext(value: Int) -> Node {
            let new = Node(value, next: next, prev: self)
            next.prev = new
            next = new
            return new
        }
        func removePrev() -> Int {
            let ret = prev.value
            prev = prev.prev
            prev.next = self
            return ret
        }
    }
}
