

import Foundation
struct CountyInfo : Codable {
	let images : String?
	let flag : String?

	enum CodingKeys: String, CodingKey {

		case images = "images"
		case flag = "flag"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		images = try values.decodeIfPresent(String.self, forKey: .images)
		flag = try values.decodeIfPresent(String.self, forKey: .flag)
	}

}
