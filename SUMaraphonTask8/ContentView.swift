//
//  ContentView.swift
//  SUMaraphonTask8
//
//  Created by A.J on 22.12.2024.
//

/*
 
 - ТЗ
 
 Вертикальный слайдер. Взаимодействует с жестом. Поведение как у индикатора громкости в центре управления iPhone.
 
 - Фон слайдера черный ultraThinMaterial
 - В крайних значениях слайдер вытягивается в направлении жеста.
 - Когда отпускаем слайдер, он возвращается в оригинальное состояние.
 */

import SwiftUI

struct ContentView: View {
    
    // Параметры слайдера
    let sliderHeight: CGFloat = 200
    let sliderWidth: CGFloat = 90
    let cornerRadius: CGFloat = 20
    
    @State var currentOffset = CGFloat.zero // Текущее смещение
    @State var previousOffset = CGFloat.zero // Предыдущее смещение
    @State var fillLevel = CGFloat.zero // Уровень заполнения 0-1
    let stretchAmount: CGFloat = 0.3 // Коэффициент растяжения
    
    var body: some View {
        
        ZStack {
            
            // Фон
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 10, opaque: true)
                .edgesIgnoringSafeArea(.all)
            
            // Слайдер
            GeometryReader { geometry in
                
                // Высота заполнения
                let height = geometry.size.height
                let filledHeight = max(fillLevel, .zero) * height
                
                ZStack(alignment: .bottom) {
                    
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    Rectangle()
                        .fill(.white)
                        .frame(height: filledHeight)
                    
                }//:ZStack
                .cornerRadius(cornerRadius)
                .frame(height: fillLevel < 0 ? height + (-fillLevel * height) : nil)
                .frame(
                    maxWidth: geometry.size.width,
                    maxHeight: height,
                    alignment: fillLevel < 0 ? .top : .bottom
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            
                            // Вертикальное смещение
                            let verticalOffset = -value.translation.height + previousOffset
                            currentOffset = verticalOffset
                            
                            if verticalOffset > height {
                                
                                // вверх после заполнения
                                let excess = verticalOffset - height
                                fillLevel = 1 + (excess * stretchAmount / height)
                            } else if verticalOffset < 0 {
                                
                                // вниз
                                fillLevel = verticalOffset * stretchAmount / height
                            } else {
                                
                                // стандартное
                                fillLevel = verticalOffset / height
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.spring(
                                response: 0.3,
                                dampingFraction: 0.8,
                                blendDuration: 0
                            )) {
                                fillLevel = max(0, min(fillLevel, 1))
                                previousOffset = fillLevel * height
                                currentOffset = previousOffset
                            }
                        }
                )
                
            }//:GeometryReader
            .frame(width: sliderWidth, height: sliderHeight)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
        }//:ZStack
    }
}

#Preview {
    
    ContentView()
    
}

