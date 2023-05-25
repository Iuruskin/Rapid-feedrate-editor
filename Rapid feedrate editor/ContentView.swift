//
//  ContentView.swift
//  Rapid feedrate editor
//
//  Created by Кирилл Юрушкин on 12.03.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentFeedrate = ""
    @State private var safeZ = ""
    @State private var newFeedrate = ""
    
    @State private var oldGcode = ""
    @State private var newGcode = ""
    @State private var urlOfOldGcode : URL?
    @State private var urlOfNewGcode : URL?
    @State private var count = 0
    @State private var sheet = false
    
    var body: some View {
        VStack {
            Text("Fusion 360 rapid feedrate editor")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)
                
            Divider()
            
            Button {
                urlOfOldGcode = showOpenPanel()
                if let code = try? String(contentsOf: urlOfOldGcode!) {
                        oldGcode = code
                    }
            } label: {
                Text("Upload file")
                Image(systemName: "globe")
                    .foregroundColor(oldGcode == "" ? .red : .green)
            }
            
            Divider()
            
                VStack {
                    Text("Введите текущее значение Cutting feedrate")
                    TextField("Current Feedrate", text: $currentFeedrate)
                }.padding()
            
                Divider()
            
                VStack {
                    Text("Введите текущее значение параметра Retract heights, параметр должен быть уникальным дробным числом")
                    TextField("Safe Z", text: $safeZ)
                }.padding()
            
                Divider()
            
                VStack {
                    Text("Введите новое значение холостых перемещений")
                    TextField("New rapid feedrate", text: $newFeedrate)
                }.padding()
            
            
                Button {
                    newGcode = changeRapid(gCode: oldGcode, safeZ: Double(safeZ)!, currentFeedrate: Int(currentFeedrate)!, newFeedrate: Int(newFeedrate)!).0
                    count = changeRapid(gCode: oldGcode, safeZ: Double(safeZ)!, currentFeedrate: Int(currentFeedrate)!, newFeedrate: Int(newFeedrate)!).1
                    
                    sheet.toggle()
                } label: {
                    Text("Generate new g-Code")
                }
        }
        .confirmationDialog("Values have been seccessfully replased, Number of changed values: \(count)", isPresented: $sheet, actions: {
            Button {
                urlOfNewGcode = showSavePanel()
                saveGcode(url: urlOfNewGcode, gCode: newGcode)
            } label: {
                Text("Save")
            }

        })
        .padding()
        .frame(width: 400.0, height: 600.0)
    }
}












struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

