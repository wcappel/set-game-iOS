//
//  SetApp.swift
//  Set
//
//  Created by Wilton Cappel on 3/11/22.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = SetVM()
    
    var body: some Scene {
        WindowGroup {
            SetView(game: game)
        }
    }
}
