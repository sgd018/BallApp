//
//  ContentView.swift
//  BallApp
//
//  Created by csi1 on 8/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var score = 0 // Puntuación del jugador
    @State private var ballSize: CGFloat = 80 // Tamaño de la pelota
    @State private var ballPosition = CGPoint(x: 50, y: 50) // Posición inicial de la pelota
    @State private var ballVelocity = CGSize(width: 8, height: 5) // Velocidad inicial de la pelota
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white // Fondo blanco
                    .edgesIgnoringSafeArea(.all) // Ignorar los bordes seguros del dispositivo
                
                // Pelota
                Circle() // Forma circular para representar la pelota
                    .foregroundColor(.red) // Color rojo para la pelota
                    .frame(width: self.ballSize, height: self.ballSize) // Tamaño de la pelota
                    .position(self.ballPosition) // Posición de la pelota en la pantalla
                    .onTapGesture { // Manejar el gesto de toque en la pelota
                        self.score += 1 // Aumentar la puntuación del jugador al tocar la pelota
                        self.changeBallSize() // Cambiar el tamaño de la pelota al tocarla
                    }
            }
            .gesture(
                DragGesture() // Detectar el gesto de arrastre en la pantalla
                    .onChanged { value in
                        let x = max(min(value.location.x, geometry.size.width), 0) // Limitar la posición X dentro de los límites de la pantalla
                        let y = max(min(value.location.y, geometry.size.height), 0) // Limitar la posición Y dentro de los límites de la pantalla
                        self.ballPosition = CGPoint(x: x, y: y) // Actualizar la posición de la pelota según el gesto de arrastre
                    }
            )
            .onAppear {
                // Iniciamos el temporizador para mover la pelota y cambiar su tamaño cada 0.02 segundos
                Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                    self.moveBall(in: geometry.size) // Mover la pelota en la pantalla
                }
            }
        }
        .overlay(
            Text("Puntuación: \(score)") // Mostrar la puntuación del jugador
                .font(.title) // Tamaño de la fuente del texto
                .fontWeight(.bold) // Peso de la fuente del texto
                .foregroundColor(.black) // Color del texto
                .padding() // Añadir relleno alrededor del texto
                .background(Color.white.opacity(0.5)) // Fondo del texto con opacidad
                .cornerRadius(10) // Bordes redondeados del fondo del texto
                .padding() // Añadir más relleno alrededor del texto
                .shadow(radius: 5) // Añadir sombra alrededor del texto
            , alignment: .topTrailing // Posición del texto en la pantalla
        )
    }
    
    private func moveBall(in size: CGSize) {
        // Aumentamos la velocidad gradualmente
        if self.ballVelocity.width < 10 {
            self.ballVelocity.width *= 1.001 // Aumentar la velocidad horizontal
            self.ballVelocity.height *= 1.001 // Aumentar la velocidad vertical
        }
        
        // Actualizamos la posición de la pelota según la velocidad
        self.ballPosition.x += self.ballVelocity.width // Mover la pelota horizontalmente
        self.ballPosition.y += self.ballVelocity.height // Mover la pelota verticalmente
        
        // Revisamos si la pelota ha alcanzado los límites de la pantalla y cambiamos la dirección
        if self.ballPosition.x > size.width || self.ballPosition.x < 0 {
            self.ballVelocity.width *= -1 // Cambiar la dirección horizontal de la pelota
        }
        
        if self.ballPosition.y > size.height || self.ballPosition.y < 0 {
            self.ballVelocity.height *= -1 // Cambiar la dirección vertical de la pelota
        }
    }
    
    private func changeBallSize() {
        // Cambiamos el tamaño de la pelota gradualmente
        if self.ballSize > 10 {
            self.ballSize -= 1 // Reducir el tamaño de la pelota
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView() // Mostrar la vista de contenido
    }
}
