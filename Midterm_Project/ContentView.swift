//
//  ContentView.swift
//  Midterm_Project
//
//  Created by Banibe Ebegbodi on 10/7/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject var flashcardManager = FlashcardSetManager()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    ZStack {
                        Circle()
                            .frame(width: 195)
                            .shadow(color: .gray, radius: 15, x: 15, y: 15)
                        Circle()
                            .fill(.purple.gradient)
                            .frame(width: 200)
                            .overlay {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.white)
                            }
                    }
                    Text("FlashAI")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .padding(.bottom, 30)
                        .gradientForeground(colors: [Color.darkPurple, .purple])
                    
                    VStack {
                        Text("Less time making.")
                            .padding(1)
                        Text("More time studying.")
                    }
                    .font(.system(size: 23, design: .rounded))
                    .padding(.bottom, 40)
                    .foregroundColor(.secondary)
                    
                        NavigationLink(destination: SignUp()) {
                            Text("Sign Up")
                                .font(.system(size: 35, weight: .semibold, design: .rounded))
                        }
                        .buttonStyle(GradientBackgroundStyle())
                        
                    NavigationLink(destination: Login()) {
                        Text("Log In")
                            .font(.system(size: 35, weight: .semibold, design: .rounded))
                    }
                    .buttonStyle(GradientBackgroundStyle(bgColor1: Color.darkGray.opacity(0.75), bgColor2: Color.gray.opacity(0.8)))
                }
                .padding(30)
            }
            .environmentObject(flashcardManager)
        }
        .navigationBarBackButtonHidden(true)
    }
}

//add animation on the button maybe 
//gradient button
struct GradientBackgroundStyle: ButtonStyle {
    var bgColor1 = Color.darkPurple
    var bgColor2 = Color.purple
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [bgColor1, bgColor2]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

//gradient text
extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(
            LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
        )
        .mask(self)
    }
}



#Preview {
    ContentView().environmentObject(FlashcardSetManager())
}
