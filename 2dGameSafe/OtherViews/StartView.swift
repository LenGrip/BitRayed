//
//  StartView.swift
//  BitRayed
//
//  Created by Ali Haidar on 23/06/24.
//

import SwiftUI
import AVFoundation

struct StartView: View{
    
    @StateObject private var audioPlayer = AudioPlayer()
    @State var navigateToGame = false
    @State private var isLoading = false
    
    var body: some View {
        ZStack{
            RainfallView()
            
            
            VStack{
                
                Spacer()
                
                GlitchText()
                
                Spacer()
                
                Button(action: {
                    isLoading = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        navigateToGame = true
                        isLoading = false
                    }
                }) {
                    Text("New Game")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 24).frame(width: 250))
                }
                Button(action: {
                    
                }) {
                    Text("Continue")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 24).frame(width: 250))
                }
                Button(action: {
                    
                }) {
                    Text("Credits")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 24).frame(width: 250))
                }
                Button(action: {
                    exit(0)
                }) {
                    Text("Exit")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 24).frame(width: 250))
                }
                
                Spacer()
            }
            
            if isLoading {
                LoadingView()
            }
        }
        
        .onAppear{
            audioPlayer.playSound(sound: "main_music", type: "wav")
        }
        .navigationDestination(isPresented: $navigateToGame){
            MainGameView()
        }
        
    }
}

//#Preview {
//    StartView()
//}
