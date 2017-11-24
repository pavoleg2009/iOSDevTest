
import Foundation

struct Country: Codable {
	let name: String?
	let continent: String?
	let capital: String?
	let population: Int?
	let descriptionSmall : String?
	let countryDescription : String?
	let image : String?
	let countyInfo : CountyInfo?

	enum CodingKeys: String, CodingKey {

		case name
		case continent
		case capital
		case population
		case descriptionSmall = "description_small"
		case countryDescription = "description"
		case image
		case countyInfo
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		continent = try values.decodeIfPresent(String.self, forKey: .continent)
		capital = try values.decodeIfPresent(String.self, forKey: .capital)
		population = try values.decodeIfPresent(Int.self, forKey: .population)
		descriptionSmall = try values.decodeIfPresent(String.self, forKey: .descriptionSmall)
		countryDescription = try values.decodeIfPresent(String.self, forKey: .countryDescription)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		countyInfo = try CountyInfo(from: decoder)
	}

}
