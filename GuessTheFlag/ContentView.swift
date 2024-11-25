//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Aditya Sharma on 22/11/24.
//

import SwiftUI

struct GameState{
    var showingAlert=false
    var showMessage=""
    var score=0
    var number=0
    var showFinalScore=false
    var showFinalMessage=""
}

struct questionNumber: ViewModifier{
    var number: String
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing){
            content
            Text("\(number)/8")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(20)
        }
    }
}

extension View{
    func questionNumberd(with number: String) -> some View{
        modifier(questionNumber(number: number))
    }
}

struct ContentView: View {
    @State var countries=["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Spain","UK","Ukraine","US"]
        .shuffled()
    @State var correctAnswers=Int.random(in: 0...2)
    @State private var gameState=GameState()
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red:0.1,green:0.2,blue:0.45), location: 0.3),
                .init(color: Color(red:0.76, green:0.15, blue:0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white )
                Text("Question Number: \(gameState.number+1)/8")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 10))
           
                VStack(spacing:15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswers])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in
                        Button{
                            checkAnswer(number)
                        }
                        label:{
                            FlagImage(country: countries[number])
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical,20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .questionNumberd(with: "\(gameState.number+1)")
                Spacer()
                Spacer()
                Text("Score is \(gameState.score)")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
        }
        .alert(gameState.showFinalMessage, isPresented: $gameState.showFinalScore){
            Button("Continue",action: askQuestion)
        } message: {
            Text("\(gameState.score)")
        }
        .alert(gameState.showMessage,isPresented: $gameState.showingAlert){
            Button("Continue",action: askQuestion)
            Button("Reset",role: .cancel,action:resetScore )
        } message: {
            Text("Your Score Is \(gameState.score)")
        }
        
    }
    
    struct FlagImage: View {
        var country: String
        var body: some View {
            Image(country)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    func resetScore(){
        gameState.score=0
        gameState.number=0
    }
    
    func checkNumberQuestion(){
        if(gameState.number==8){
            gameState.showFinalMessage="Your Final Score Is"
            gameState.showFinalScore=true
            gameState.showingAlert=false
        }
        else{
            gameState.showingAlert=true
        }
    }
    
    func checkAnswer(_ numbers:Int){
        
        if numbers==correctAnswers{
            gameState.showMessage="correct"
            gameState.score+=1
        }
        else{
            gameState.showMessage="Wrong That's the Flag of \(countries[numbers])"
        }
        gameState.number+=1
        checkNumberQuestion()
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswers=Int.random(in: 0...2)
        if gameState.showFinalScore{
            resetScore()
            gameState.showFinalScore=false
        }
    }
}
#Preview {
    ContentView()
}
