//
//  main.swift
//  Microsoft_Coding_Test_SingleThread
//
//  Created by Saleh Sultan on 2/26/18.
//  Copyright © 2018 SwordfishTech. All rights reserved.
//

import Foundation

class WordNode {
    let word:String
    var parent:WordNode?
    
    init(wString: String, wParent:WordNode?) {
        word = wString
        parent = wParent
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

func printPath(node: WordNode, count:Int) {
    if startNode.word == node.word {
        print("Total Word Count: \(count) \nFull Path of shortest Path: -> \n\(node.word)")
    }
    else {
        // Since the question said "all intermediate words in the transformation must exist in the dictionary". So I am considering there is a path from target word to start word. Otherwise I have to check if there is a parent available for that word or not.
        printPath(node: node.parent!, count: count+1)
        print(node.word)
    }
}

let startNode = WordNode(wString: "smart", wParent: nil)
let endNode = WordNode(wString: "brain", wParent: nil)

var wordDictionary = NSMutableArray()
wordDictionary.add(WordNode(wString: "slack", wParent: nil))
wordDictionary.add(WordNode(wString: "braid", wParent: nil))
wordDictionary.add(WordNode(wString: "btarn", wParent: nil))
wordDictionary.add(WordNode(wString: "blank", wParent: nil))
wordDictionary.add(WordNode(wString: "brarn", wParent: nil))
wordDictionary.add(WordNode(wString: "brain", wParent: nil))
wordDictionary.add(WordNode(wString: "stark", wParent: nil))
wordDictionary.add(WordNode(wString: "black", wParent: nil))
wordDictionary.add(WordNode(wString: "bland", wParent: nil))
//wordDictionary.add(WordNode(wString: "btart", wParent: nil))
wordDictionary.add(WordNode(wString: "STart", wParent: nil))
wordDictionary.add(WordNode(wString: "smArk", wParent: nil))
wordDictionary.add(WordNode(wString: "brand", wParent: nil))
wordDictionary.add(WordNode(wString: "stack", wParent: nil))


var bfsQueue = [WordNode]()
bfsQueue.append(startNode)

var foundShortestPath = false
while(!bfsQueue.isEmpty && !foundShortestPath) {
    guard let firstNode = bfsQueue.first else {
        break
    }

    bfsQueue.removeFirst()
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue.global(qos: .default).async {
        for wNodeObj in wordDictionary {
            
            if let wNode = wNodeObj as? WordNode {
                if isAdjucentString(curWord: firstNode.word, adjucentWord: wNode.word) {
                    wNode.parent = firstNode
                    bfsQueue.append(wNode)
                    wordDictionary.remove(wNode)
                    
                    if wNode.word == endNode.word {
                        endNode.parent = firstNode
                        foundShortestPath = true
                        break
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

printPath(node: endNode, count: 0)
