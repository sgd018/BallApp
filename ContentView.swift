//
//  ContentView.swift
//  BallApp
//
//  Created by csi1 on 8/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var ballSize: CGFloat = 80
    @State private var ballPosition = CGPoint(x: 50, y: 50)
    @State private var ballVelocity = CGSize(width: 8, height: 5) // Velocidad inicial
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                // Pelota
                Circle()
                    .foregroundColor(.red)
                    .frame(width: self.ballSize, height: self.ballSize)
                    .position(self.ballPosition)
                    .onTapGesture {
                        self.score += 1
                        self.changeBallSize()
                        
                    }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let x = max(min(value.location.x, geometry.size.width), 0)
                        let y = max(min(value.location.y, geometry.size.height), 0)
                        self.ballPosition = CGPoint(x: x, y: y)
                    }
            )
            .onAppear {
                // Iniciamos el temporizador para mover la pelota y cambiar su tamaño cada 2 segundos
                Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                    self.moveBall(in: geometry.size)
                }
                
                /*Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                    self.changeBallSize()
                }*/
            }
        }
        .overlay(
            Text("Puntuación: \(score)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(10)
                .padding()
                .shadow(radius: 5)
            , alignment: .topTrailing
        )
    }
    
    private func moveBall(in size: CGSize) {
        // Aumentamos la velocidad gradualmente
        if self.ballVelocity.width < 10 {
            self.ballVelocity.width *= 1.001
            self.ballVelocity.height *= 1.001
        }
        
        // Actualizamos la posición de la pelota según la velocidad
        self.ballPosition.x += self.ballVelocity.width
        self.ballPosition.y += self.ballVelocity.height
        
        // Revisamos si la pelota ha alcanzado los límites de la pantalla y cambiamos la dirección
        if self.ballPosition.x > size.width || self.ballPosition.x < 0 {
            self.ballVelocity.width *= -1
        }
        
        if self.ballPosition.y > size.height || self.ballPosition.y < 0 {
            self.ballVelocity.height *= -1
        }
    }
    
    private func changeBallSize() {
        // Cambiamos el tamaño de la pelota gradualmente
        if self.ballSize > 10 {
            self.ballSize -= 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
