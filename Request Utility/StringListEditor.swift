//
//  StringListEditor.swift
//  Request Utility
//
//  Created by Teddy Gaillard on 12/5/20.
//

import SwiftUI

struct StringListEditor: View {
	@Binding var stringsList: Array<(k:String, v:String)>
	let name: String
	let plKeyName: String
	let plValName: String
    var body: some View {
		VStack {
			HStack {
				Text(name)
					.font(.title)
				Button(action: {stringsList.append((k:"", v:""))}) {
					Text("+")
				}
			}
			if stringsList.count > 0 {
				ForEach(0..<stringsList.count, id: \.self) {i in
					HStack {
						TextField(plKeyName, text: $stringsList[i].k)
						TextField(plValName, text: $stringsList[i].v)
						Button(action: {stringsList.remove(at: i)}, label: {Text("-")})
					}
					.padding(.horizontal)
				}
			}
		}
    }
}
