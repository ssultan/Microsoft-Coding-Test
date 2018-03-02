//
//  main.swift
//  Microsoft_Coding_Test_SingleThread
//
//  Created by Saleh Sultan on 2/26/18.
//  Copyright © 2018 SwordfishTech. All rights reserved.
//

import Foundation

let RedColor = "Red"
let GreenColor = "Green"

class WordNode {
    let word:String
    var distance:Int
    var parent:WordNode?
    var color: String?
    
    init(wString: String, wDistance:Int, wParent:WordNode?, wordColor:String?) {
        word = wString
        parent = wParent
        color = wordColor
        distance = wDistance
    }
}


func isAdjucentString(curWord:String, adjucentWord:String) -> Bool {
    var counter = 0
    
    for (index, char) in adjucentWord.enumerated() {
        let x = curWord.index(curWord.startIndex, offsetBy: index)
        
        // Convert character to lowercase. Considering input word can be a upper case word
        if String(char).lowercased() != String(curWord[x]).lowercased() {
            counter += 1
        }
        if counter > 1 {
            return false
        }
    }
    return true
}

func printPrePath(node: WordNode) {
    if node.parent == nil {
        print(node.word)
        return
    }
    else {
        // Since the question said "all intermediate words in the transformation must exist in the dictionary". So I am considering there is a path from target word to start word. Otherwise I have to check if there is a parent available for that word or not.
        printPrePath(node: node.parent!)
        print(node.word)
    }
}

func printPostPath(node: WordNode) {
    if node.parent == nil {
        print(node.word)
        return
    }
    else {
        // Since the question said "all intermediate words in the transformation must exist in the dictionary". So I am considering there is a path from target word to start word. Otherwise I have to check if there is a parent available for that word or not.
        print(node.word)
        printPostPath(node: node.parent!)
    }
}

let startNode = WordNode(wString: "smart", wDistance:0, wParent: nil, wordColor:RedColor)
let endNode = WordNode(wString: "brain", wDistance:0, wParent: nil, wordColor:GreenColor)

var wordDictionary = [WordNode]()
wordDictionary.append(WordNode(wString: "slack", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "braid", wDistance:0, wParent: nil, wordColor:nil))
//wordDictionary.append(WordNode(wString: "btarn", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "blank", wDistance:0, wParent: nil, wordColor:nil))
//wordDictionary.append(WordNode(wString: "brarn", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "brain", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "stark", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "black", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "bland", wDistance:0, wParent: nil, wordColor:nil))
//wordDictionary.append(WordNode(wString: "btart", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "STart", wDistance:0, wParent: nil, wordColor:nil))
//wordDictionary.append(WordNode(wString: "smArk", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "brand", wDistance:0, wParent: nil, wordColor:nil))
wordDictionary.append(WordNode(wString: "stack", wDistance:0, wParent: nil, wordColor:nil))

/*
 WE ARE CONSIDERING THAT THE DICTIONARY MUST CONTIAN THE TARGET VALUE AND all intermediate words in the transformation must exist in the dictionary
 */

var bfsQueue = [WordNode]()
bfsQueue.append(startNode)
bfsQueue.append(endNode)

var foundShortestPath = false
var distranceTraveled = Int(UInt32.max)
var printStartNode:WordNode!
var printEndNode:WordNode!

TestGoto:
while !bfsQueue.isEmpty && !foundShortestPath {
    guard let firstNode = bfsQueue.first else {
        break
    }
    
    bfsQueue.removeFirst()
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue.global(qos: .default).async {
        for wNode in wordDictionary {
            if isAdjucentString(curWord: firstNode.word, adjucentWord: wNode.word) {
                if wNode.color == nil {
                    wNode.parent = firstNode
                    wNode.distance = firstNode.distance + 1
                    wNode.color = firstNode.color
                    bfsQueue.append(wNode)
                }
                else if wNode.color != firstNode.color {
                    foundShortestPath = true
                    if distranceTraveled > wNode.distance + firstNode.distance + 1 {
                        distranceTraveled = wNode.distance + firstNode.distance + 1
                        
                        // For printing all the nodes
                        if wNode.color == RedColor {
                            printStartNode = wNode
                            printEndNode = firstNode
                        } else {
                            printStartNode = firstNode
                            printEndNode = wNode
                        }
                    }
                }
            }
        }
        group.leave()
    }
    if bfsQueue.count == 0 {
        group.wait()
    }
}

print("Total Distance tranveled: \(distranceTraveled)")
printPrePath(node: printStartNode)
printPostPath(node: printEndNode)
