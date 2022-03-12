//
//  SetModel.swift
//  Set
//
//  Created by Wilton Cappel on 3/11/22.
//

import Foundation

struct SetModel {
    private(set) var cards: Array<Card>
    private(set) var revealedCards: Array<Card>
    
    init() {
        cards = []
        var count = 0
        for color in colors {
            for shape in shapes {
                for shade in shading {
                    for i in 1...3 {
                        count += 1
                        let newCard = Card(id: count, numShapes: i, shape: shape, shading: shade, color: color, inPlay: true)
                        cards.append(newCard)
                    }
                }
            }
        }
        cards.shuffle()
        revealedCards = []
    }
    
    mutating func addThree() {
        if cards.count >= 3 {
            for _ in 0..<3 {
                let popped: Card = cards.remove(at: 0)
                revealedCards.append(popped)
            }
        }
    }
    
    func countSelected() -> Int {
        var count = 0
        for index in revealedCards.indices {
            if revealedCards[index].selected {
                count += 1
            }
        }
        return count
    }
    
    func checkForSet() {
        //todo
    }
    
    mutating func selectCard(id: Int) {
        for index in revealedCards.indices {
            let numOfSelected: Int = countSelected()
            if revealedCards[index].id == id {
                if revealedCards[index].selected == false && numOfSelected < 3 {
                    revealedCards[index].selected.toggle()
                } else if revealedCards[index].selected == true {
                    revealedCards[index].selected.toggle()
                }
            }
        }
        
    }
    
    private let colors: Array<String> = ["orange", "purple", "blue"]
    private let shapes: Array<String> = ["circle", "rectangle", "diamond"]
    private let shading: Array<String> = ["solid", "striped", "open"]
    
    struct Card: Identifiable {
        let id: Int
        let numShapes: Int
        let shape: String
        let shading: String
        let color: String
        var inPlay: Bool = true
        var selected: Bool = false
    }
}
