//
//  Setting.swift
//  calculator
//
//  Created by 三浦将太 on 2022/04/07.
//

import SwiftUI

struct SettingView: View {
    @State var image: UIImage? = UserDefaults.standard.image(forKey: "background")
    @State var showingAlert: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Background Image")) {
                ZStack {
                    Text("No Image")
                        .font(Font.system(size: 24).bold())
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 200)
                        .background(Color(UIColor.lightGray))
                    Image(uiImage: image!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipped()
                }
                HStack {
                    Image(systemName: "square.and.pencil")
                    Button("Change Background Image", action: {
                        showingAlert = true
                    })
                }.sheet(isPresented: $showingAlert) {
                } content: {
                    ImagePicker(image: $image)
                }
                HStack {
                    Button("Delete Background Image", action: {
                        UserDefaults.standard.removeObject(forKey: "background")
                        image = UserDefaults.standard.image(forKey: "background")
                    })
                }
            }
            Section(footer: Text("copyright ©︎ 2022 Shota Miura All Rights Reserved.")) {
            }.navigationBarTitle("Settings")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
