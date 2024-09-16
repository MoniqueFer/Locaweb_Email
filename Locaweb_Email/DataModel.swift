//
//  DataModel.swift
//  Locaweb_Email
//
//  Created by Monique Ferrarini on 12/09/24.
//

import Foundation
import Alamofire


struct MyDataTest: Codable {
	let name: String
	let last_name: String
	let email: String
	let configs: ConfigsWrapper
	let emails: [Email]
}

struct ConfigsWrapper: Codable {
	let configs: Configs
}

struct Configs: Codable {
	let present_full_name: Bool
	let is_dark_mode: Bool
}

enum EmailType: String, Codable {
	case received, draft, sent
}

enum EmailCategory: String, Codable {
	case normal, important, spam
}

struct Email: Codable, Identifiable {
	let sent_date: Int
	let id: String
	let type: EmailType
	let hash: String
	let to: String
	let from: String
	let cc: String?
	let subject: String
	let content: String
	let category: EmailCategory
}
