//
//  ExploreCollections.swift
//  Midterm_Project
//
//  Created by Banibe Ebegbodi on 10/14/24.
//

import SwiftUI

struct ExploreCollections: View {
    //@Binding var savedFlashcardSets: [FlashcardSet]
    @EnvironmentObject var flashcardManager: FlashcardSetManager
    var body: some View {
        VStack {
            HStack {
                Text("Your Collection")
                    .font(.system(size: 45, design: .rounded))
                    .bold()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 80))
                    .gradientForeground(colors: [Color.darkPurple, .purple])
                Spacer()
            }
            .padding(30)
            
            List {
                ForEach(flashcardManager.flashcardSets) { flashcardSet in
                    NavigationLink(destination: FlashcardSetDetailView(flashcardSet: flashcardSet)) {
                        Text(flashcardSet.title)
                    }
                }
                .onDelete(perform: deleteSet)
            }
            .onAppear {
                print(flashcardManager.flashcardSets)
            }
            
            
        //adding more stuff
        NavigationLink(destination: NewSet()) {
            Image(systemName: "plus")
                .font(.system(size: 50))
                .foregroundColor(.white)
        }
        .buttonStyle(GradientBackgroundStyle())
        .padding(.horizontal, 90)
        .padding(.top, 30)
    }
        Spacer()
        .navigationBarBackButtonHidden(true)
    }
    
    func deleteSet(at offsets: IndexSet) {
        flashcardManager.deleteFlashcardSet(at: offsets)
    }
}

struct FlashcardSetDetailView: View {
    var flashcardSet: FlashcardSet
    @State private var currentCardIndex = 0
    @State private var isFlipped = false
    
    var body: some View {
        VStack {
            Text(flashcardSet.title)
                .font(.largeTitle)
                .padding()
        
                VStack {
                    //flashcard with flip animation
                    ZStack {
                        // Front of card
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 300, height: 340)
                            
                            Text(flashcardSet.flashcards[currentCardIndex].question)
                                .font(.title)
                                .frame(width: 275)
                                .multilineTextAlignment(.center)
                        }
                        .opacity(isFlipped ? 0 : 1)
                        .rotation3DEffect(
                            .degrees(isFlipped ? 180 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        
                        // Back of card
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 300, height: 340)
                            
                            Text(flashcardSet.flashcards[currentCardIndex].answer)
                                .font(.title)
                                .frame(width: 275)
                                .multilineTextAlignment(.center)
                        }
                        .opacity(isFlipped ? 1 : 0)
                        .rotation3DEffect(
                            .degrees(isFlipped ? 0 : -180),
                            axis: (x: 0, y: 1, z: 0)
                        )
                    }
                    .animation(.default, value: isFlipped)
                    .onTapGesture {
                        withAnimation {
                            isFlipped.toggle()
                        }
                    }
                    
                    //forwrdd/back buttons
                    HStack {
                        Button(action: {
                            if currentCardIndex > 0 {
                                currentCardIndex -= 1
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        
                        Button(action: {
                            if currentCardIndex < flashcardSet.flashcards.count - 1 {
                                currentCardIndex += 1
                            }
                        }) {
                            Image(systemName: "arrow.right")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
            }
        }
    }
}

#Preview {
    ExploreCollections().environmentObject(FlashcardSetManager())
}
