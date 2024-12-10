//
//  Midterm_ProjectApp.swift
//  Midterm_Project
//
//  Created by Banibe Ebegbodi on 10/7/24.
//

import SwiftUI

@main
struct Midterm_ProjectApp: App {
    @StateObject private var flashcardManager = FlashcardSetManager()
    var body: some Scene {
        WindowGroup {
            ExploreCollections().environmentObject(flashcardManager)
        }
    }
}
