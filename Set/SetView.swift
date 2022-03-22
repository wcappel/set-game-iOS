//
//  SetView.swift
//  Set
//
//  Created by Wilton Cappel on 3/11/22.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var game: SetVM
    @Namespace private var dealingNamespace
    @Namespace private var discardingNamespace
    @State private var dealt = Set<Int>()
    @State private var discarded = Set<Int>()

    var body: some View {
        VStack {
            Text("Set").font(.largeTitle).padding()
            AspectVGrid(items: game.revealedCards, aspectRatio: 2/3, content: { card in
                CardView(card: card).padding(4)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                    .onTapGesture {
                        withAnimation(dealAndDiscardAnimation()) {
                            game.replaceMatched()
                        }
                        game.selectCard(id: card.id)
                    }.animation(card.matched ? .easeIn : .none, value: card.matched)
            }).padding()
            HStack {
                discardedPile
                Spacer()
                deckBody
            }.padding(.horizontal, 65)
            Button(action: {
                game.newGame()
            }, label : {
                Text("New Game").font(.title2)
            }).padding(.horizontal, 35)
        }
    }
    
    var deckBody: some View {
        return ZStack {
            ForEach(game.undealtCards) { card in
                CardView(card: card).matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }.frame(width: 2/3 * CGFloat(90), height: CGFloat(90))
            .onTapGesture {
                withAnimation(dealAndDiscardAnimation()) {
                    game.replaceMatched()
                }
                withAnimation(dealAndDiscardAnimation()) {
                    game.addThree()
                }
            }
    }
    
    var discardedPile: some View {
        ZStack {
            ForEach(game.discardedCards) { card in
                CardView(card: card).matchedGeometryEffect(id: card.id, in: discardingNamespace)
            }
        }.frame(width: 2/3 * CGFloat(90), height: CGFloat(90))
    }
    
    private func deal(_ card: SetVM.Card) {
        dealt.insert(card.id)
    }
    
    private func discard(_ card: SetVM.Card) {
        discarded.insert(card.id)
    }
    
    private func dealAndDiscardAnimation() -> Animation {
        return Animation.easeInOut(duration: 0.5)
    }
    
    struct CardView: View {
        let card: SetVM.Card
        
        var cardColor: Color {
            if card.color == "blue" {
                return Color.blue
            } else if card.color == "orange" {
                return Color.orange
            } else if card.color == "purple" {
                return Color.purple
            } else {
                return Color.black
            }
        }
        
        func makeCardShape(card: SetVM.Card) -> some View {
            return Group {
                if card.shape == "rectangle" {
                    if card.shading == "open" {
                        Rectangle().strokeBorder(lineWidth: 2)
                    } else if card.shading == "striped" {
                        Rectangle().opacity(0.5)
                    } else {
                        Rectangle()
                    }
                } else if card.shape == "circle" {
                    if card.shading == "open" {
                        Circle().strokeBorder(lineWidth: 2)
                    } else if card.shading == "striped" {
                        Circle().opacity(0.5)
                    } else {
                        Circle()
                    }
                } else if card.shape == "diamond" {
                    //replace w/ custom diamond shape
                    if card.shading == "open" {
                        Ellipse().strokeBorder(lineWidth: 2)
                    } else if card.shading == "striped" {
                        Ellipse().opacity(0.5)
                    } else {
                        Ellipse()
                    }
                }
            }.aspectRatio(2, contentMode: .fit)
        }
        
        var body: some View {
            GeometryReader(content: {geometry in
                ZStack() {
                    let cardForm = card.selected ? AnyView(RoundedRectangle(cornerRadius: 10).strokeBorder(.blue, lineWidth: 4)) : (card.matched ? AnyView(RoundedRectangle(cornerRadius: 10).strokeBorder(.green, lineWidth: 4)) : AnyView(RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 3)))
                    RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white)
                    if card.faceUp {
                        cardForm
                        VStack() {
                            ForEach(1..<card.numShapes + 1, id: \.self) {shape in
                                makeCardShape(card: card).foregroundColor(cardColor)
                            }
                        }.padding(10)
                    } else {
                        AnyView(RoundedRectangle(cornerRadius: 10).fill(.black))
                    }
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetVM()
        SetView(game: game)
.previewInterfaceOrientation(.portrait)
        SetView(game: game)
            .previewInterfaceOrientation(.portrait).preferredColorScheme(.dark)
    }
    
}

