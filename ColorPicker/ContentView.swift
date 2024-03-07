//
//  ContentView.swift
//  ColorPicker
//
//  Created by Сергей Дубовой on 06.03.2024.
//

import SwiftUI

struct ContentView: View {
    // Выбранный цвет
    @State var selectedColor: Color = .red.opacity(0.5)
    
    // Показывать выбор цветов или нет
    @State var showColorPicker = false
    
    var body: some View {
        ZStack {
            // Просто картинка со схемой. Пришлоось все равно лезть в UIKit, чтобы можно было нормально картинку зумить... Честно скоммуниздил с интернетов)
            ZoomableScrollView {
                Image("scheme")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            if showColorPicker {
                // Вся магия тут
                MarkerColorPickerView(selectedColor: $selectedColor) {
                    // изменить значение showColorPicker, чтобы закрыть выбор цвета
                    withAnimation {
                        showColorPicker.toggle()
                    }
                }
            } else {
                // Просто нижняя строка с выбранным цветом
                HStack {
                    Text("Selected color:")
                        .foregroundStyle(.blue)
                    Spacer()
                    selectedColor
                        .frame(width: 20, height: 20)
                }
                .padding()
                .background{
                    Color.init(white: 0.8)
                        .opacity(0.8)
                        .shadow(radius: 10)
                }
                .cornerRadius(15)
                .contentShape(Rectangle())
                .onTapGesture {
                    // По нажатии будет открыт выбор цветов
                    withAnimation {
                        showColorPicker = true
                    }
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
//                ColorPicker("Selected color", selection: $selectedColor, supportsOpacity: true)
            }
        }
    }
}

#Preview {
    ContentView()
}
