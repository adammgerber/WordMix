//
//  ContentView.swift
//  WordMix
//
//  Created by Adam Gerber on 06/11/2022.
//

import SwiftUI

struct ContentView: View {
   
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    func addNewWord() {
        //lowercase and trim the word so that theres no duplicates
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //exit if the remaining string is empty
        guard answer.count > 0 else { return }
        
        //extra validation to come
        
        //using insert here instead of append because we want it to appear at the beginning of the list. Otherwise it would show off screen
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        //1. Find the URL for start.txt in the app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            //2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL){
                //3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                //4. Pick one random word, or use "toybox" as a default word
                rootWord = allWords.randomElement() ?? "toybox"
                //5. Everything worked if made it to this point
                return
            }
        }
        // If we got here, then there was an error. Crash the app and see what happened
        fatalError("Could not load start.txt from bundle.")
        
    }
    
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id: \.self){ word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
