//
//  NewSet.swift
//  Midterm_Project
//
//  Created by Banibe Ebegbodi on 10/14/24.
//

import SwiftUI
import GoogleGenerativeAI

struct Flashcard: Identifiable, Codable {
    let id = UUID()
    var question: String
    var answer: String
}
    
struct FlashcardSet: Identifiable, Codable {
    let id = UUID()
    var title: String
    var flashcards: [Flashcard]
}

struct NewSet: View {
    
    @State private var topicInput = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Generate Flashcards ")
                        .font(.system(size: 45, design: .rounded))
                        .bold()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 80))
                        .gradientForeground(colors: [Color.darkPurple, .purple])
                    Spacer()
                }
                .padding(EdgeInsets(top: 30, leading: 30, bottom: 0, trailing: 0))
                
                ZStack {
                    TextField("Enter Topic...", text: $topicInput, axis: .vertical)
                        .font(.system(size: 25))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.leading)
                        .offset(y: -90)
                }
                .frame(width: 320, height: 250)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                     .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                
                
                NavigationLink(destination: FlashcardsPreview(topic: topicInput)) {
                    Text("Generate")
                        .font(.system(size: 35, weight: .semibold, design: .rounded))
                }
                .buttonStyle(GradientBackgroundStyle())
                .padding(30)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

//displaying flashcards after generating
@MainActor
struct FlashcardsPreview: View {
    @EnvironmentObject var flashcardManager: FlashcardSetManager
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State private var currentCardIndex = 0
    @State private var isFlipped = false
    @State private var flashcards: [Flashcard] = []
    @State private var isLoading = true
    @State private var showSaveSheet = false
    //@State private var savedFlashcardSets: [FlashcardSet] = []
    @State private var navigateToExplore = false
    
    var topic: String
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Generating flashcards...")
                } else if flashcards.isEmpty {
                    Text("No flashcards were generated. Please try again.")
                } else {
                    VStack {
                        //flashcard with flip animation
                        ZStack {
                            // ront of card
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 300, height: 340)
                                
                                Text(flashcards[currentCardIndex].question)
                                    .font(.title)
                                    .frame(width: 275)
                                    .multilineTextAlignment(.center)
                            }
                            .opacity(isFlipped ? 0 : 1)
                            .rotation3DEffect(
                                .degrees(isFlipped ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            
                            //Back of card
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 300, height: 340)
                                
                                Text(flashcards[currentCardIndex].answer)
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
                                if currentCardIndex < flashcards.count - 1 {
                                    currentCardIndex += 1
                                }
                            }) {
                                Image(systemName: "arrow.right")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        
                        //Save button
                        Button(action: {
                            showSaveSheet = true
                        }) {
                            Text("Save")
                                .font(.system(size: 35, weight: .semibold, design: .rounded))
                        }
                        .buttonStyle(GradientBackgroundStyle())
                        .padding(.horizontal, 30)
                        .padding(.top, 30)
                        .sheet(isPresented: $showSaveSheet) {
                            SaveSheetView(
                                flashcards: flashcards,
                                onSave: {
                                    navigateToExplore = true
                                }
                                //savedFlashcardSets: $savedFlashcardSets
                            ).environmentObject(flashcardManager)
                        }
                        
                        //canncel button
                        NavigationLink(destination: Home()) {
                            Text("Cancel")
                                .font(.system(size: 35, weight: .semibold, design: .rounded))
                        }
                        .buttonStyle(GradientBackgroundStyle(bgColor1: Color.darkGray.opacity(0.75), bgColor2: Color.gray.opacity(0.8)))
                        .padding(.horizontal, 30)
                    }
                } //if else
                } //group
                .navigationDestination(isPresented: $navigateToExplore) {
                    ExploreCollections().environmentObject(flashcardManager)
                }
                .navigationBarBackButtonHidden(true)
            } //nav stack
            .onAppear {
                fetchFlashcards()
        }
        
    }
        //calling the api
        func fetchFlashcards() {
            isLoading = true
            
            Task {
                do {
                    let prompt = "Create 20 flashcards about \(topic). Format each flashcard as 'Question: <question> | Answer: <answer>'. Separate each flashcard with a newline."
                    let response = try await model.generateContent(prompt)
                    
                    if let text = response.text {
                        let cards = text.components(separatedBy: "\n").filter { !$0.isEmpty}
                        flashcards = cards.compactMap { card -> Flashcard? in
                            //seperating flashcards into answer/question
                            let parts = card.components(separatedBy: "|")
                            guard parts.count == 2 else { return nil }
                            
                            
                            let question = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                .replacingOccurrences(of: "Question: ", with: "")
                            let answer = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                                .replacingOccurrences(of: "Answer: ", with: "")
                            
                            return Flashcard(question: question, answer: answer)
                        }
                    }
                    isLoading = false
                } catch {
                    isLoading = false
                    print("Error generating flashcards: \(error)")
                }
            }
        
        }
    }
    
//Savesheet View
struct SaveSheetView: View {
    //@Binding var showSaveSheet: Bool
    @State private var collectionTitle = ""
    let flashcards: [Flashcard]
    //@Binding var savedFlashcardSets: [FlashcardSet]
    @EnvironmentObject var flashcardManager: FlashcardSetManager
    //@Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    //@State private var isNavigateToExplore: Bool = false
    var onSave: () -> Void //trying to trigger navigation
    
    var body: some View {
            VStack {
                Text("Enter Title for Flashcard Set")
                    .font(.title)
                    .padding()
                
                TextField("Flashcard Set Title", text: $collectionTitle)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                Button(action: {
                    guard !collectionTitle.isEmpty else {
                            print("Error: Title is empty!")
                            return
                    }
                    Task {
                        let flashcardSet = FlashcardSet(title: collectionTitle, flashcards: flashcards)
                        //savedFlashcardSets.append(flashcardSet)
                        flashcardManager.addFlashcardSet(flashcardSet)
                        //showSaveSheet = false
                        //isNavigateToExplore = true
                        //presentationMode.wrappedValue.dismiss()
                        dismiss()
                        //isNavigateToExplore = true
                        onSave()
                    }
                }) {
                    Text("Save")
                        .font(.system(size: 35, weight: .semibold, design: .rounded))
                }
                .buttonStyle(GradientBackgroundStyle())
                .padding()
                
            }
            .padding()
            .interactiveDismissDisabled()
    }
}

//moving flashcards to explore and managing it
class FlashcardSetManager: ObservableObject {
    @Published var flashcardSets: [FlashcardSet] = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    init() {
        loadFromUserDefaults()
    }
    
    func addFlashcardSet(_ set: FlashcardSet) {
        flashcardSets.append(set)
    }
    
    func deleteFlashcardSet(at offsets: IndexSet) {
        flashcardSets.remove(atOffsets: offsets)
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(flashcardSets) {
            UserDefaults.standard.set(encoded, forKey: "flashcardSets")
        }
    }
    
    private func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "flashcardSets"),
           let decoded = try? JSONDecoder().decode([FlashcardSet].self, from: data) {
            flashcardSets = decoded
        }
    }
}



#Preview {
    NewSet().environmentObject(FlashcardSetManager())
}
