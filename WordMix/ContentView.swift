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
    
    //Main gameplay
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
    //Method to check if word entered doesnt exist already
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    //Method Two to check if user's input can be made from original word. Loop over user's word and if it exists in original word then remove it from copy so it cant be read twice
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    //Method Three to check if word is an actual English word
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
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
                            Image(systemName: "\(word.count).circle.fill")
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
