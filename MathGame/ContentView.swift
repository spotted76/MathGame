//
//  ContentView.swift
//  MathGame
//
//  Created by Peter Fischer on 3/23/22.
//

import SwiftUI

struct SettingsView : View {
    
    @State var level : Int
    @State var numSelect : Int
    @State var playGame : (Int, Int) -> Void
    
    var numGames : [Int] = [5,10,15, 20]
    
    var body : some View {
        NavigationView {
            Form {
                
                Section {
                    Stepper("Level \(level)", value: $level, in: 2...12)
                } header: {
                    Text("Difficulty")
                }
                
                Section("Number of Games") {
                    Picker("Game Picker", selection: $numSelect) {
                        ForEach(numGames, id: \.self) { game in
                            Text("\(game)")
                        }
                    }.pickerStyle(.segmented)
                }
                
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Start Game") {
                    print("Going to call \(level) and \(numSelect)")
                    return playGame(level, numSelect)
                }
            }
            
        }
    }
}


struct AnswerButton : ViewModifier {

    func body(content: Content) -> some View {
        
        content
            .frame(width: 75, height: 40, alignment: .center)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
    }
}

extension View {
    func styleButton() -> some View {
        modifier(AnswerButton())
    }
}


struct GameView : View {
        
    @State var numGames : Int
    @State var difficulty : Int
    @State var endGame : () -> Void
    
    @State var questions = (One : 0, Two: 0)
    @State var answers = [0,0,0,0]
    @State var correctAnswer = 0
    @State var correctIndex = 0

    var body : some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.white, .gray, .white], startPoint: .top, endPoint: .bottom)
                VStack {
                    Text("\(questions.One) X \(questions.Two)")
                        .font(.system(size: 75, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity)
                        .frame(height: 175)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding()
                
                    
                    Group {
                        VStack(alignment: .center, spacing: 40) {
                            HStack(spacing: 75) {
                                Button("\(answers[0])") {
                                    buttonSelected(answer: 0)
                                }
                                    .styleButton()
                                Button("\(answers[1])") {
                                    buttonSelected(answer: 1)
                                }
                                    .styleButton()
                            }
                            HStack(spacing: 75) {
                                Button("\(answers[2])") {
                                    buttonSelected(answer: 2)
                                }
                                    .styleButton()
                                Button("\(answers[3])") {
                                    buttonSelected(answer: 3)
                                }
                                    .styleButton()
                            }
                        }
                        
                    }
                                            
                }
                .toolbar{
                    
                    Button("Settings") {
                        print(correctAnswer)
                        print(answers)
                        endGame()
                    }
                }
                .onAppear() {
                    buildQuestion()
                }
            }
            .ignoresSafeArea()
        }
    }
    
    func buildQuestion() {
        questions.One = Int.random(in: 1...difficulty)
        questions.Two = Int.random(in: 1...difficulty)
        
        //Build the correct answer
        correctAnswer = questions.One * questions.Two
        
        //Now build a bank of potential answers
        answers[0] = correctAnswer
        for idx in 1...3 {
            var tempAnswer = Int.random(in: 1...difficulty) * Int.random(in: 1...difficulty)
            while tempAnswer == correctAnswer {
                tempAnswer = Int.random(in: 1...difficulty) * Int.random(in: 1...difficulty)
            }
            answers[idx] = tempAnswer
        }
        answers.shuffle()
        correctIndex = answers.firstIndex(of: correctAnswer)!
        
    }
    
    func buttonSelected(answer : Int) {
        if answers[answer] == correctAnswer {
            print("YOU GOT IT RIGHT")
        }
        else {
            print("YOU ARE INCORRECT")
        }
        
        buildQuestion()
        
    }

}


struct ContentView: View {
    
    @State private var playingGame = true
    
    @State private var numGames = 10
    @State private var difficulty = 12
    
    var body: some View {
        
        VStack {
            if !playingGame {
                SettingsView(
                    level: self.difficulty,
                    numSelect: self.numGames,
                    playGame: startGame(level:numGames:))
            }
            else {
                GameView(numGames: numGames, difficulty: difficulty, endGame: toggleGameState)
            }
        }
    }
    
    func startGame(level : Int, numGames : Int)
    {
        print("Start the Game!!:  \(level) - \(numGames)")
        self.difficulty = level
        self.numGames = numGames
        toggleGameState()
    }
    
    func toggleGameState() -> Void {
        withAnimation(.easeIn) {
            self.playingGame.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
