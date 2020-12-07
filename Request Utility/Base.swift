//
//  Base.swift
//  Request Utility
//
//  Created by Teddy Gaillard on 12/5/20.
//

import Foundation
import AppKit

func makeRequest(url: String, data: Array<(k:String, v:String)>, dataMethod: DataMethods, useSecure: Bool, headers: Array<(k:String, v:String)>, callback: @escaping (_ error: Error?, _ data: String?) -> Void) {
	let prefix = useSecure ? "https://" : "http://"
	var request = URLRequest(url: URL(string: prefix+url)!)
	for (header, value) in headers {
		request.setValue(value, forHTTPHeaderField: header)
	}
	var dataDict: Dictionary<String, String> = [:]
	for (ki, vi) in data {
		dataDict[ki] = vi
	}
	let bodyData = dataDict.percentEncoded()
	request.httpMethod = dataMethod.rawValue
	if data.count > 0 {
		request.httpBody = bodyData
	}
	let session = URLSession.shared
	let task = session.dataTask(with: request) { (data, response, error) in
		if let error = error {
			callback(error, nil)
		} else if let data = data {
			callback(nil, String(data: data, encoding: .ascii))
		}
	}
	task.resume()
}

extension Dictionary {
	func percentEncoded() -> Data? {
		return map { key, value in
			let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			return escapedKey + "=" + escapedValue
		}
		.joined(separator: "&")
		.data(using: .utf8)
	}
}

extension CharacterSet {
	static let urlQueryValueAllowed: CharacterSet = {
		let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
		let subDelimitersToEncode = "!$&'()*+,;="

		var allowed = CharacterSet.urlQueryAllowed
		allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		return allowed
	}()
}

func saveFile(withString: String, andFileName: String) {
	let panel = NSOpenPanel()
	panel.canChooseDirectories = true
	panel.canChooseFiles = false
	if panel.runModal() == .OK {
		let filename = panel.url!
		try! withString.data(using: .utf8)!.write(to: filename.appendingPathComponent(andFileName))
	}
}
