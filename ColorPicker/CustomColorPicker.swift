//
//  CustomColorPicker.swift
//  ColorPicker
//
//  Created by Сергей Дубовой on 06.03.2024.
//

import SwiftUI

struct CustomColorPicker: View {
    // Выбранный цвет
    @Binding var selectedColor: Color
    
    // Базовый цвет без прозрачности
    @State private var baseColor: Color
    // прозрачность
    @State private var opacity: Double
    
    init(selectedColor: Binding<Color>) {
        self._selectedColor = selectedColor
        
        // разделяем цвет на ргба компоненты
        let color = UIColor(selectedColor.wrappedValue)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        self._baseColor = State(initialValue: Color(red: r, green: g, blue: b))
        self._opacity = State(initialValue: a)
    }
    
    // Размеры градиентной сетки. Нужно для определения,
    // на какой цвет кликнул пользователь
    @State private var size: CGSize = .zero
    
    
    var body: some View {
        VStack {
            // Показываем выбранный цвет, можно сделать покрасивее)
            HStack{
                Text("Selected color:")
                selectedColor
                    .frame(width: 20, height: 20)
            }
            
            // GeometryReader нужен, чтобы узнать размеры градиентной сетки
            GeometryReader { proxy in
                // сама градентная сетка
                GradientGrid()
                    .onAppear {
                        // тут размер как раз и обновляется при показе на экране
                        self.size = proxy.size
                    }
            }
            .frame(height: 250) // GeometryReader захватывает по возможности все место на экране, поэтому его нужно ограничить вручную
            .gesture(
                // жест, чтобы отслеживать, куда пользователь тычет
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        // вызываем фунцию по тыкнутой координате
                        colorSelected(at: gesture.location)
                    }
            )
            
            // слайдер для прозрачности, также можэно сделать и покрасивее
            HStack {
                Text("Opacity:")
                
                Slider(value: $opacity, in: 0...1)
                    .onChange(of: opacity) { newValue in
                        // При изменении прозрачности обновляем выбранный цвет
                        // Тут икскод ругается на то, что в 17 айос этот метод не работает, но он работает) И также работает с 15
                        updateSelectedColor()
                    }
            }
        }
    }
    
    // Вызывается, если пользователь ткнул в градиентную сетку
    func colorSelected(at location: CGPoint) {
        // Отбрасываем значения вне сетки, тк по каким-то причинам он также обрабатывает значения отступов слева и справа
        guard location.x >= 0, location.x <= size.width, location.y >= 0, location.y <= size.height else { return }
        print(size, location)
        // Высчитываем размеры кубика
        let squareHeight = size.height / GradientGrid.rows
        let squareWidth = size.width / GradientGrid.cols
        
        // Получаем координаты кубика
        let row = Int(location.y / squareHeight)
        let col = Int(location.x / squareWidth)
        print(row, col)
        // Устанавливаем новый базовый цвет
        setNewBaseColor(GradientGrid.getColor(row, col))
    }
    
    func setNewBaseColor(_ newColor: Color) {
        // Устанавливаем бызовый цвет
        baseColor = newColor
        // обновляем выбранный цвет
        updateSelectedColor()
    }
    
    func updateSelectedColor()
    {
        // Устанавливаем выбранный цвет как базовый плюс прозрачность
        selectedColor = baseColor.opacity(opacity)
    }
}

// чтобы в канве можно было потыкать
struct CustomColorPickerDemo: View {
    @State var selectedColor: Color = .red.opacity(0.5)
    
    var body: some View {
        CustomColorPicker(selectedColor: $selectedColor)
            .padding()
    }
}

#Preview {
    CustomColorPickerDemo()
}
