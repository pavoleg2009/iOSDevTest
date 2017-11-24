import UIKit

struct CountryBriefViewModel {
    
    let name: String
    let capital: String?
    let image: URL?
    let descriptionSmall : String?
    
    static let emptyNews = CountryBriefViewModel(name: "", capital: "", image: nil, descriptionSmall: "")
    
    init(name: String, capital: String?, image: URL?, descriptionSmall: String?) {
        self.name = name
        self.capital = capital
        self.image = image
        self.descriptionSmall = descriptionSmall
    }
    
}
