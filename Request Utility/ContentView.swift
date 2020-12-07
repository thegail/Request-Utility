//
//  ContentView.swift
//  Request Utility
//
//  Created by Teddy Gaillard on 12/4/20.
//

import SwiftUI

enum DataMethods: String {
	case GET = "GET"
	case POST = "POST"
}

struct ContentView: View {
	@State var urlIn = ""
	@State private var headers: Array<(k:String, v:String)> = []
	@State private var urlData: Array<(k:String, v:String)> = []
	@State private var dataMethod = DataMethods.GET
	@State private var useSecure = true
	@State private var response = "Response"
	@State private var fileWriteOut = ""
    var body: some View {
		VStack {
			TextField("URL", text: $urlIn)
				.padding(.all)
			HStack {
				VStack {
					Toggle("Use HTTPS", isOn: $useSecure).toggleStyle(CheckboxToggleStyle()).frame(width: 300, height: 100, alignment: .bottom)
					StringListEditor(stringsList: $headers, name: "Headers", plKeyName: "Header Field", plValName: "Header Value").padding(.leading).frame(width: 300, height: 300, alignment: .top).border(Color.secondary)
				}
				VStack {
					Picker("Data Protocol", selection: $dataMethod, content: {
						Text("GET").tag(DataMethods.GET)
						Text("POST").tag(DataMethods.POST).frame(width: 100, height: 10, alignment: .leading)
					}).pickerStyle(RadioGroupPickerStyle()).frame(width: 300, height: 100, alignment: .bottom)
					StringListEditor(stringsList: $urlData, name: "URL Data", plKeyName: "Data Field", plValName: "Data Value").padding(.trailing).frame(width: 300, height: 300, alignment: .top).border(Color.secondary)
				}
			}
			Button(action: {
				makeRequest(url: urlIn, data: urlData, dataMethod: dataMethod, useSecure: useSecure, headers: headers, callback: { err, data in
					if let data = data {
						response = data
					} else if let err = err {
						response = "Error: \(err.localizedDescription)"
					} else {
						response = "Unknown Error"
					}
				})
			}, label: {Text("Request")}).padding(.bottom)
			ScrollView(content: {
				Text(response).font(.system(.body, design: .monospaced)).padding([.top, .leading])
			}).frame(width: 600, height: 300, alignment: .topLeading).border(Color.secondary)
			HStack {
				TextField("Save Filename", text: $fileWriteOut)
				Button("Save", action: {
					saveFile(withString: response, andFileName: fileWriteOut)
				})
			}
		}
    }
}

struct ContentViewPreview: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
