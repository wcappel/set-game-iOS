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
    private(set) var discardedCards: Array<Card>
    
    init() {
        cards = []
        var count = 0
        for color in colors {
            for shape in shapes {
                for shade in shading {
                    for i in 1...3 {
                        count += 1
                        let newCard = Card(id: count, numShapes: i, shape: shape, shading: shade, color: color, faceUp: false)
                        cards.append(newCard)
                    }
                }
            }
        }
        cards.shuffle()
        revealedCards = []
        discardedCards = []
    }
    
    mutating func addThree() {
        if cards.count >= 3 {
            for _ in 0..<3 {
                var popped: Card = cards.remove(at: 0)
                popped.faceUp = true
                revealedCards.append(popped)
            }
        }
    }
    
    func getSelected() -> Array<Card> {
        var selected: Array<Card> = []
        for index in revealedCards.indices {
            if revealedCards[index].selected {
                selected.append(revealedCards[index])
            }
        }
        return selected
    }
    
    mutating func replaceMatched() {
        var newRevealedCards: Array<Card> = []
        for index in revealedCards.indices {
            if !revealedCards[index].matched {
                newRevealedCards.append(revealedCards[index])
            } else {
                var discard = revealedCards[index]
                discard.matched = false
                discard.selected = false
                discardedCards.append(discard)
            }
        }
        revealedCards = newRevealedCards
    }
    
    enum setStatus {
        case different
        case mixed
        case same
    }
    
    func checkPropertyMatch<T>(prop1: T, prop2: T, prop3: T) -> setStatus where T: Equatable {
        print("\(prop1), \(prop2), \(prop3)")
        if (prop1 == prop2 && prop2 == prop3) {
            return setStatus.same
        } else if (prop1 != prop2 && prop2 != prop3 && prop3 != prop1) {
            return setStatus.different
        } else {
            return setStatus.mixed
        }
    }
    
    func checkForSet(selected: Array<Card>) -> Bool {
        print("checking")
        let shapeSet = checkPropertyMatch(prop1: selected[0].shape, prop2: selected[1].shape, prop3: selected[2].shape)
        let colorSet = checkPropertyMatch(prop1: selected[0].color, prop2: selected[1].color, prop3: selected[2].color)
        let shadingSet = checkPropertyMatch(prop1: selected[0].shading, prop2: selected[1].shading, prop3: selected[2].shading)
        let numberSet = checkPropertyMatch(prop1: selected[0].numShapes, prop2: selected[1].numShapes, prop3: selected[2].numShapes)
        
        if shapeSet == .different && colorSet == .different && shadingSet == .different && numberSet == .different {
            print("set found")
            return true
        } else if shapeSet == .different && colorSet == .same && shadingSet == .same && numberSet == .same {
            print("set found")
            return true
        } else if shapeSet == .same && colorSet == .different && shadingSet == .same && numberSet == .same {
            print("set found")
            return true
        } else if shapeSet == .same && colorSet == .same && shadingSet == .different && numberSet == .same {
            print("set found")
            return true
        } else if shapeSet == .same && colorSet == .same && shadingSet == .same && numberSet == .different {
            print("set found")
            return true
        } else {
            print("no set found")
            return false
        }
    }
    
    mutating func selectCard(id: Int) {
        for index in revealedCards.indices {
            var selected: Array<Card> = getSelected()
            if revealedCards[index].id == id {
                if revealedCards[index].selected == false && selected.count < 3 && !revealedCards[index].matched {
                    revealedCards[index].selected.toggle()
                    selected.append(revealedCards[index])
                    if selected.count == 3 {
                        let result: Bool = checkForSet(selected: selected)
                        print(result)
                        if result {
                            for index in revealedCards.indices {
                                if revealedCards[index].selected == true {
                                    revealedCards[index].matched = true
                                    revealedCards[index].selected = false
                                }
                            }
                        }
                    } else {
                        break
                    }
                } else if revealedCards[index].selected == true {
                    revealedCards[index].selected.toggle()
                } else if revealedCards[index].selected == false && selected.count >= 3 {
                    for index in revealedCards.indices {
                        if revealedCards[index].id == id {
                            revealedCards[index].selected = true
                        } else {
                            revealedCards[index].selected = false
                        }
                    }
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
        var faceUp: Bool = true
        var selected: Bool = false
        var matched: Bool = false
    }
}
