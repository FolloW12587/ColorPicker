//
//  MarkerColorPickerView.swift
//  ColorPicker
//
//  Created by Сергей Дубовой on 06.03.2024.
//

import SwiftUI

struct MarkerColorPickerView: View {
    // Выбранный цвет
    @Binding var selectedColor: Color
    
    // Замыкание, чтобы себя закрыть
    let dismissAction: () -> ()
    
    // Переключалка превью режима и выбора цветов
    @State private var isPreviewing = false
    
    // Для анимации кнопки сохранения выбора
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            // Заливаем все выбранным цветом.
            selectedColor
                .ignoresSafeArea() // Чтобы залился весь экран
                .onTapGesture {
                    // По нажатию на него, переходим в режим превью
                    withAnimation {
                        isPreviewing = true
                    }
                }
            
            // Нижнее белое всплывающее окно
            VStack {
                if isPreviewing {
                    // В режиме превью показываются две кнопки
                    HStack {
                        // Кнопка изменить - выход из режима превью
                        Button(action: {
                            withAnimation {
                                isPreviewing.toggle()
                            }
                        }) {
                            Text("Change")
                        }
                        .frame(maxWidth: .infinity) // Чтобы кнопки занимали равное место и были посередине своей стороны
                        
                        // Кнопка сохранить - сохранить текущее значение. По факту просто закрыть эту вьюху
                        Button(action: dismissAction) {
                            // задаю стиль кнопки
                            Text("Save")
                                .foregroundStyle(.white)
                                .padding()
                                .frame(minWidth: 100)
                                .background(.blue)
                                .cornerRadius(15)
                                .matchedGeometryEffect(id: "save", in: animation) // магия с анимацией кнопки
                        }
                        .frame(maxWidth: .infinity) // Чтобы кнопки занимали равное место и были посередине своей стороны
                    }
                } else {
                    // Режим выбора цвета
                    
                    // Кнопка чтобы перейти в режим превью
                    Button(action: {
                        withAnimation {
                            isPreviewing.toggle()
                        }
                    }) {
                        Text("Preview")
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Здесь находится сам выбор цветов
                    CustomColorPicker(selectedColor: $selectedColor)
                    
                    // Кнопка сохранения цвета
                    Button(action: dismissAction) {
                        Text("Save")
                            .foregroundStyle(.white)
                            .padding()
                            .frame(minWidth: 100)
                            .background(.blue)
                            .cornerRadius(15)
                            .matchedGeometryEffect(id: "save", in: animation) // магия с анимацией кнопки
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding() // Чтобы контент отступал от краев
            .padding(.bottom) // чтобы контента снизу был дополнительный отступ, тк мы заливаем весь экран
            .background(Color.white) // Белый фон
            .cornerRadius(15) // закругляем края, чтобы казалось, что это всплывающее окно
            .frame(maxHeight: .infinity, alignment: .bottom) // привязываем к нижнему краю экрана
            .ignoresSafeArea() // Чтобы снизу не было некрасивой дырки, поэтому делали отступ снизу
        }
    }
}

// Чтобы можно было менять значения в канве
private struct MarkerColorPickerViewDemo: View {
    @State var selectedColor = Color.red.opacity(0.5)
    
    var body: some View {
        MarkerColorPickerView(selectedColor: $selectedColor, dismissAction: {})
    }
}

#Preview {
    MarkerColorPickerViewDemo()
}
