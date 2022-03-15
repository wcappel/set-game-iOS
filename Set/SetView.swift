//
//  SetView.swift
//  Set
//
//  Created by Wilton Cappel on 3/11/22.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var game: SetVM

    var body: some View {
        VStack {
            Text("Set").font(.largeTitle).padding()
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                CardView(card: card).padding(4)
                    .onTapGesture {
                        game.selectCard(id: card.id)
                    }
            }).padding()
            HStack {
                Button(action: {
                    game.newGame()
                }, label : {
                    Text("New Game").font(.title2)
                }).padding(.horizontal, 35)
                Spacer()
                Button(action: {
                    game.addThree()
                }, label: {
                    Text("Add 3 Cards").font(.title2)
                }).opacity(game.outOfCards ? 0 : 1).padding(.horizontal, 35)
            }
        }
    }
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
                let cardForm = card.selected ? AnyView(RoundedRectangle(cornerRadius: 10).strokeBorder(.blue, lineWidth: 4)) : (card.matched ? AnyView(RoundedRectangle(cornerRadius: 10).strokeBorder(.green, lineWidth: 4)) : AnyView(RoundedRectangle(cornerRadius: 10).strokeBorder()))
                RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white)
                if card.inPlay {
                    cardForm
                    VStack() {
                        ForEach(1..<card.numShapes + 1, id: \.self) {shape in
                            makeCardShape(card: card).foregroundColor(cardColor)
                        }
                    }.padding(10)
                }
            }
        })
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

