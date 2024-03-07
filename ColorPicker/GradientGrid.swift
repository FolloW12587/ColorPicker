//
//  GradientGrid.swift
//  ColorPicker
//
//  Created by Сергей Дубовой on 07.03.2024.
//

import SwiftUI

struct GradientGrid: View {
    // кол-во строк и столюцов. Сделал в статике, чтобы к ним был доступ отовсюду, что полезно для рассчета, куда кликнул пользователь
    static let rows: Double = 10
    static let cols: Double = 12
    
    // рассчет цвета по координатам
    static func getColor(_ row: Int, _ col: Int) -> Color {
        // Первая строка - оттенки серого
        if row == 0 {
            let colorComp = 1-Double(col)/(GradientGrid.cols-1)
            return Color(red: colorComp, green: colorComp, blue: colorComp)
        }
        
        // Цветные
        // Насыщенность угасает, вначале медленно потом быстро
        let saturation = pow(1 - Double(row)/(GradientGrid.rows), 1/3)
        // Яркость наоборот возрастает. Чуть медленне. Можно поиграться со значениями. 1/GradientGrid.rows - это некоторое начальное значение, чтобы первая строка не была совсем черной, и в принципе, чтобы вся сетка была немного светлее
        let brightness = pow(1/GradientGrid.rows + Double(row)/(GradientGrid.rows), 1/2)
        // Тон - просто с шагом проходим по всему спектру, кроме последнего значения, тк тон 0 и тон 1 - это все равно красный
        let hue = Double(col-1) / GradientGrid.cols
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<Int(GradientGrid.rows), id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach(0..<Int(GradientGrid.cols), id: \.self){ j in
                        GradientGrid.getColor(i, j)
                    }
                }
            }
        }
    }
}

#Preview {
    GradientGrid()
        .frame(height: 300)
}
