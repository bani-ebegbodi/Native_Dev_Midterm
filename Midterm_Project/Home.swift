//
//  Home.swift
//  Midterm_Project
//
//  Created by Banibe Ebegbodi on 10/12/24.
//

import SwiftUI

struct Home: View {
    @StateObject var flashcardManager = FlashcardSetManager()
    var body: some View {
        NavBar()
            .background(.clear)
            .opacity(1)
        NavigationView {
            VStack {
                HStack {
                    Text("Home")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .gradientForeground(colors: [Color.darkPurple, .purple])
                    Spacer()
                }
                .padding(.horizontal, 30)
                NavigationLink(destination: NewSet()) {
                    Text("Create New Set")
                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                        .frame(height: 150)
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .padding(.horizontal, 80)
                }
                .buttonStyle(GradientBackgroundStyle())
                .padding()
                
                NavigationLink(destination: ExploreCollections()) {
                    Text("Explore My Collections")
                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                        .frame(height: 150)
                        .lineSpacing(10)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 60)
                }
                .buttonStyle(GradientBackgroundStyle(bgColor1: Color.darkGray.opacity(0.75), bgColor2: Color.gray.opacity(0.8)))
                .padding()
                
            }
            .padding(.bottom, 120)
            .environmentObject(flashcardManager)
        }
    }
}

struct NavBar: View {
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: Home()) {
                    ZStack {
                        Circle()
                            .fill(.purple.gradient)
                            .frame(width: 30)
                            .overlay {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 5)
                    }

                    Text("FlashAI")
                        .gradientForeground(colors: [Color.darkPurple, .purple])
                        .font(.system(size: 25))
                }
                .navigationBarBackButtonHidden(true)
                Spacer()
                //include navigation link to either logout or have overlay with those options
                NavigationLink(destination: ContentView()) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            Divider()
        }
        .padding(20)
    }
}

#Preview {
    Home().environmentObject(FlashcardSetManager())
}
