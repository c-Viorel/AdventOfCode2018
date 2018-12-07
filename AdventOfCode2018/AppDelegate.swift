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

        printRuntimes = true
        
        Day1().showSolutions()
        Day2().showSolutions()
        Day3().showSolutions()
        Day4().showSolutions()
        Day5().showSolutions()
        Day6().showSolutions()
        Day7().showSolutions()

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

