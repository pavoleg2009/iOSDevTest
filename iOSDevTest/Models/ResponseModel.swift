import Foundation

struct ResponseModel : Codable {
	let next : String?
	let countries : [Country]?

	enum CodingKeys: String, CodingKey {

		case next = "next"
		case countries = "countries"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		next = try values.decodeIfPresent(String.self, forKey: .next)
		countries = try values.decodeIfPresent([Country].self, forKey: .countries)
	}

}
