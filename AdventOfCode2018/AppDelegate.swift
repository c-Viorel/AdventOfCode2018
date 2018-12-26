//
//  AppDelegate.swift
//  AdventOfCode2018
//
//  Created by Viorel Porumbescu on 07/12/2018.
//  Copyright © 2018 Viorel Porumbescu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let date1 = Date()
        printRuntimes = true
        Day1().showSolutions()
        Day2().showSolutions()
        Day3().showSolutions()
        Day4().showSolutions()
        Day5().showSolutions()
        Day6().showSolutions()
        Day7().showSolutions()
        Day8().showSolutions()
        Day9().showSolutions()
        Day10().showSolutions()
        Day11().showSolutions()
        Day12().showSolutions()
        Day13().showSolutions()
        Day14().showSolutions()
        Day15().showSolutions()
        Day16().showSolutions()
        Day17().showSolutions()
        Day18().showSolutions()
        Day19().showSolutions()
        Day20().showSolutions()
//        Day21().showSolutions()
        Day22().showSolutions()
        Day23().showSolutions()
        Day24().showSolutions()
        Day25().showSolutions()
        if printRuntimes {
            let run = Date().timeIntervalSince(date1)
            print("Completed all solutions in \(String.init(format: "%.6f", run)) sec.")
        }


    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
}

