//
//  ContentView.swift
//  calculator
//
//  Created by 三浦将太 on 2022/04/06.
//

import SwiftUI

struct ContentView: View {
    @State var items: [String] = ["0"]
    @State var caluculatedNumber: String = "0"
    @State var setting: Bool = false
    @State var image: UIImage = UserDefaults.standard.image(forKey: "background")
    
    private let caluculateItems: [[String]] = [
        ["⚙", "%", "DEL", "AC"],
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "×"],
        ["1", "2", "3", "-"],
        [".", "0", "=", "+"],
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                     .ignoresSafeArea()
                VStack {
                    NavigationLink(destination: SettingView(), isActive: $setting) {
                        EmptyView()
                    }
                    
                    HStack{
                        Spacer()
                        ForEach(items, id: \.self) { items in
                               Text(items)
                                .font(.system(size: 17, weight: .light))
                                .foregroundColor(Color.white)
                                .lineLimit(1)
                        }
                    }.padding()
                    
                    HStack {
                        Spacer()
                        Text(caluculatedNumber)
                            .font(.system(size: 100, weight: .light))
                            .foregroundColor(Color.white)
                            .padding()
                            .lineLimit(1)
                    }
                    
                    ZStack {
                        GeometryReader { geometry in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .onAppear{image = UserDefaults.standard.image(forKey: "background")}
                        }
                            
                        VStack(spacing: 0) {
                            ForEach(caluculateItems, id: \.self) { caluculateitems in
                                NumberView(items: $items, caluculatedNumber: $caluculatedNumber, setting: $setting, caluculateItems: caluculateitems)
                            }
                        }
                    }
                }.padding(.bottom, 70)
            }
        }.navigationViewStyle(.stack)
    }
}

struct NumberView: View {
    @Binding var items: [String]
    @Binding var caluculatedNumber: String
    @Binding var setting: Bool

    var caluculateItems: [String]
    
    private let buttonWidth: CGFloat = (UIScreen.main.bounds.width - 50) / 4
    private let buttonHeight: CGFloat = (UIScreen.main.bounds.height * 0.6) / 5
    private let numbers: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    private let calculation: [String] = ["÷", "×", "-", "+"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(caluculateItems, id: \.self) { item in
                VStack(spacing: 0){
                    HStack {
                        Button {
                            button(item: item)
                        } label: {
                            Text(item)
                                .font(.system(size: 30, weight: .regular))
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        }
                        .foregroundColor(Color.white)
                        .frame(width: buttonWidth)
                        
                        Rectangle()
                            .foregroundColor(borderW(item: item))
                            .frame(width: 1)
                    }
                    
                    Rectangle()
                        .foregroundColor(borderH(item: item))
                        .frame(height: 1)
                }
            }
            .frame(height: buttonHeight)
        }
    }
    
    private func borderW(item: String) -> Color {
        let bottomLine: [String] = ["AC", "÷", "×", "-", "+"]
        if bottomLine.contains(item) {
            return Color.clear
        }else {
            return Color(white: 0.2, opacity: 1)
        }
    }
    
    private func borderH(item: String) -> Color {
        let bottomLine: [String] = ["+", "=", "0", "."]
        if bottomLine.contains(item) {
            return Color.clear
        }else {
            return Color(white: 0.2, opacity: 1)
        }
    }
    
    private func button(item: String) {
        if numbers.contains(item) {
            
            if items.count >= 20 {
                return
            }
            
            if items == ["0"] {
                items = [item]
                return
            }
            
            items.append(item)
        } else if item == "." {
            if items.contains("."){
                let point = Int(items.lastIndex(of: ".") ?? 0)
                for (_, element) in calculation.enumerated() {
                    if items[point...].contains(element){
                        items.append(item)
                        return
                    }
                }
                return
            }
            items.append(item)
        } else if item == "AC" {
            items.removeAll()
            items.append("0")
            caluculatedNumber = "0"
        } else if item == "DEL" {
            items.removeLast()
            if items.count == 0 {
                items.append("0")
                caluculatedNumber = "0"
            }
        } else if item == "⚙" {
            setting = true
        }
        
        if items != ["0"] && items.last != "."{
            if calculation.contains(item) {
                items.append(item)
            }else if item == "%" {
                for (_, element) in calculation.enumerated() {
                    if items.contains(element){
                        return
                    }
                }
                items.append("* 0.01")
                caluculate()
            }else if item == "=" {
                
                for (index, element) in items.enumerated() {
                    if element == "×" {
                        items[index] = "*"
                    }else if element == "÷" {
                        items[index] = "/"
                    }
                }
                
                if !items.contains(".") {
                    items.append(".0")
                }
                
                caluculate()
            }
        }
    }
    
    private func caluculate() {
        let equation = items.joined(separator: "")
        let expression = NSExpression(format: equation)
        let answer = expression.expressionValue(with: nil, context: nil) as! Double
        let checkAnswer = testcheckDecimal(number: answer)
        print(equation)
        print(answer)
        items.removeAll()
        items = [checkAnswer]
        caluculatedNumber = checkAnswer
    }
    
    private func testcheckDecimal(number: Double) -> String {
        if abs(number.truncatingRemainder(dividingBy: 1)).isLess(than: .ulpOfOne) {
            return String(Int(number))
        } else {
            return String(number)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
