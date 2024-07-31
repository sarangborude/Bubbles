//
//  BubblesApp.swift
//  Bubbles
//
//  Created by Sarang Borude on 7/21/24.
//

import SwiftUI

@main
struct BubblesApp: App {

    @State private var appModel = AppModel()

    init() {
        ///Uncomment this to enable the system
        //BubblesSystem.registerSystem()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
