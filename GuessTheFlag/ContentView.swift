//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Aditya Sharma on 22/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var countries=["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Spain","UK","Ukraine","US"]
        .shuffled()
    @State var correctAnswers=Int.random(in: 0...2)
    @State private var showingAlert=false
    @State private var showMessage=""
    @State private var score=0
    
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
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical,20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score is \(score)")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
        }
        .alert(showMessage,isPresented: $showingAlert){
            Button("Continue",action: askQuestion)
            Button("Reset",role: .cancel,action:resetScore )
        } message: {
            Text("Your Score Is \(score)")
        }
        
    }
    func resetScore(){
        score=0
    }
    func checkAnswer(_ number:Int){
        if number==correctAnswers{
            showMessage="correct"
            score+=1
        }
        else{
            showMessage="Wrong"
        }
        showingAlert=true
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswers=Int.random(in: 0...2)
    }
}
#Preview {
    ContentView()
}
