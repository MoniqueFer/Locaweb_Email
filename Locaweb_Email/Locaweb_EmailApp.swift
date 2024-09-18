//
//  Locaweb_EmailApp.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 05/09/24.
//

import SwiftUI

@main
struct Locaweb_EmailApp: App {
	@StateObject private var darkModeManager = DarkModeManager()

	
    var body: some Scene {
        WindowGroup {
            LoginView()
				.environmentObject(darkModeManager) 
				
        }
    }
}
