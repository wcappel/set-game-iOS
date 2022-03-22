//
//  SetVM.swift
//  Set
//
//  Created by Wilton Cappel on 3/11/22.
//

import SwiftUI

class SetVM: ObservableObject {
    typealias Card = SetModel.Card
    @Published private var model: SetModel
    
    init() {
        model = SetVM.createSetGame()
    }
    
    private static func createSetGame() -> SetModel {
        return SetModel()
    }
    
    func newGame() {
        model = SetVM.createSetGame()
    }
    
    var revealedCards: Array<Card> {
        return model.revealedCards
    }
    
    var undealtCards: Array<Card> {
        return model.cards
    }
    
    var discardedCards: Array<Card> {
        return model.discardedCards
    }
    
    var outOfCards: Bool {
        return model.cards.isEmpty
    }
    
    func replaceMatched() {
        model.replaceMatched()
    }
    
    //MARK: - Intent(s)
    func addThree() {
        model.addThree()
    }
    
    func selectCard(id: Int) {
        model.selectCard(id: id)
    }
}
