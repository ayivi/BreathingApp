//
//  ContentView.swift
//  BreathingApp
//
//  Created by Ayivi on 11/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var showExercisePage = false
    
    var body: some View {
        if showExercisePage {
            StartExerciseView(showExercisePage: $showExercisePage)
        } else {
            LaunchScreenView(showExercisePage: $showExercisePage)
        }
    }
}

struct LaunchScreenView: View {
    @Binding var showExercisePage: Bool
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            // Centered text
            Text("breathe 🧘🏿‍♂️")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.64, green: 0.47, blue: 1))
        }
        .onAppear {
            // Automatically go to the next screen after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showExercisePage = true
            }
        }
    }
}

struct StartExerciseView: View {
    @Binding var showExercisePage: Bool
    @State private var startCountdown = false
    @State private var countdown = 3
    @State private var showBreathingScreen = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            
            if startCountdown {
                Text("ready in \(countdown)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.64, green: 0.47, blue: 1))
                    .onAppear {
                        startTimer()
                    }
            }
            
            if showBreathingScreen {
                BreathingExerciseView(showExercisePage: $showExercisePage)
            }
            
            if !startCountdown && !showBreathingScreen {
                VStack {
                    Spacer()
                    
                    Button(action: {
                        startCountdown = true
                    }) {
                        Text("start exercise")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .frame(height: 48, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color(red: 0.64, green: 0.47, blue: 1))
                            .cornerRadius(999)
                    }
                    .padding(.bottom, 32)
                }
                .padding(.bottom, 32)
            }
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                showBreathingScreen = true
                startCountdown = false
            }
        }
    }
}

struct BreathingExerciseView: View {
    @Binding var showExercisePage: Bool
    @State private var isBreathingIn = true
    @State private var circleSize: CGFloat = 0 //Start at 0
    @State private var breathText = "breathe in slowly..."
    @State private var breathOpacity = 1.0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack {
                Spacer()
                
                ZStack {
                    // Breathing circle animation
                    Circle()
                        .fill(Color(red: 0.8, green: 1, blue: 0.95).opacity(0.5))
                        .frame(width: circleSize, height: circleSize)
                        .onAppear {
                            startBreathing()
                        }
                    
                    VStack {
                        // 🧘🏿‍♂️ emoji properties
                        Text("🧘🏿‍♂️")
                            .font(.system(size: 96, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        // Breathe In/Out text with opacity transition
                        Text(breathText)
                            .font(.system(size: 17, design: .rounded))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .opacity(breathOpacity)
                        //.animation(.easeInOut(duration: 1))
                        //.padding(.top, 8)
                    }
                }
                
                Spacer()
                
                // Cancel button
                Button(action: {
                    stopBreathing()
                    showExercisePage = false // Go back to the start exercise page
                }) {
                    Text("stop exercise")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .frame(height: 48, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color(red: 0.64, green: 0.47, blue: 1))
                        .cornerRadius(999)
                }
                .padding(.bottom, 32)
            }
            .padding(.bottom, 32)
        }
    }
    
    private func startBreathing() {
        // Timer that runs every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1)) {
                if isBreathingIn {
                    // Increase size by 48px every second for "Breathe In"
                    if circleSize < 240 {
                        circleSize += 48
                    } else {
                        // Switch to "Breathe Out" phase
                        breathText = "breathe out slowly..."
                        isBreathingIn = false
                    }
                } else {
                    // Decrease size by 48px every second for "Breathe Out"
                    if circleSize > 0 {
                        circleSize -= 48
                    } else {
                        // Switch to "Breathe In" phase
                        breathText = "breathe in slowly..."
                        isBreathingIn = true
                    }
                }
            }
        }
    }
    
    private func stopBreathing() {
        timer?.invalidate()
    }
}

struct GradientBackground: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 1, green: 0.97, blue: 1), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.95, green: 0.95, blue: 1), location: 0.50),
                        Gradient.Stop(color: Color(red: 0.9, green: 0.91, blue: 1), location: 0.75),
                        Gradient.Stop(color: Color(red: 0.8, green: 1, blue: 0.95), location: 0.88),
                        Gradient.Stop(color: Color(red: 0.9, green: 0.98, blue: 0.9), location: 0.94),
                        Gradient.Stop(color: .white, location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            )
            .edgesIgnoringSafeArea(.all)  // Makes the gradient cover the whole screen
    }
}



#Preview {
    ContentView()
}
