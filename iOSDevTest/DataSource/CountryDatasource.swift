import UIKit

protocol NewsfeedDatasourceDelegate: class {
    func updateView()
}

class CountryDatasource {
    
//    weak var delegate: NewsfeedDatasourceDelegate?
//    let apiService: ApiService
    var nextFrom: String? = nil
    private var nextFromRequested = Set<String>() // to prevent duplicated request
    
    var viewModels = [CountryBriefViewModel]()
    var count: Int {
        return viewModels.count
    }
    
//    init(apiService: ApiService = VkApiService()) {
//        self.apiService = apiService
//    }

    // MARK: - Instance Methods
    func counryViewModelForRow(at indexPath: IndexPath) -> CountryBriefViewModel? {
        // Pagination
//        let rowsLeft = viewModels.count - indexPath.row
//        let isNextPageRequered =
//            rowsLeft < VkApiSettings.prefetchThreshold
//            && nextFrom != nil
//            && !nextFromRequested.contains(nextFrom!)
//
//        if isNextPageRequered {
//            log.debug("=== 🔂 [Datasourse.newsViewModelForRow] please init request with next_from: \(nextFrom ?? "<initial request>")")
//            loadPageOfNews()
//        }

        if indexPath.row < viewModels.count {
            return viewModels[indexPath.row]
        } else { return CountryBriefViewModel.emptyNews }
    }
    
    func loadFirstPage() {
        nextFrom = nil
        viewModels = [CountryBriefViewModel]()
        loadPageOfNews()
    }
    
    private func loadPageOfNews() {
        
        if let nextFrom = nextFrom { // if it's not an initial request
            nextFromRequested.insert(nextFrom) // mark request as made
        }
        
        viewModels = [
            CountryBriefViewModel(
                name: "Абхазия",
                capital:"Сухум",
                image: URL(string: "http://landmarks.ru/wp-content/uploads/2015/05/abhaziya.jpg"),
                descriptionSmall : "Республика Абхазия - частично признанное независимое государство. Кем не признано - для тех это Автономная Республика Абхазия в составе Грузии, причем оккупированная Россией."
            ),
            CountryBriefViewModel(
                name: "Австралия",
                capital:"Канберра",
                image: URL(string: "http://puteshestvia.com/uploads/images/00/00/01/2013/03/10/fb8d43.jpg"),
                descriptionSmall : "Австралия (от лат. Australis - южный), также известная как Австралийский Союз, - уникальная страна, поскольку она занимает целый одноименный континент. Впрочем, есть континенты и побольше, да и по площади своей территории Австралия занимает лишь шестое место среди стран мира."
            ),
            CountryBriefViewModel(
                name: "Аргентина",
                capital:"Буэнос-Айрес",
                image: URL(string: "https://www.votpusk.ru/country/ctimages/new/AR01.jpg"),
                descriptionSmall : ""
            ),
            CountryBriefViewModel(
            name: "Белоруссия",
            capital:"Минск",
            image: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/85/Flag_of_Belarus.svg"),
            descriptionSmall : "Белоруссия - государство в Восточной Европе. Такое наименование традиционно для россиян, в то время как сами белорусы именуют Родину как Беларусь или, официально, Республика Беларусь. В связи с этим зачастую допускаются глупые ошибки в написании: Беларуссия и Белорусь."
            )]
        
//        apiService.loadNewsData(startFrom: nextFrom) { [weak self] (data) in
//
//            guard let strongSelf = self else { return }
//            guard let jsonData = data else { return }
//            var apiRespose: NewsfeedGetResponse?
//
//            do {
//                let responseDecoder = JSONDecoder()
//                responseDecoder.dateDecodingStrategy = .secondsSince1970
//                apiRespose = try responseDecoder.decode(NewsfeedGetResponse.self, from: jsonData)
//
//            } catch DecodingError.dataCorrupted(let context) {
//                log.error("==== 🚫 Data coccupted. Description: \(context)")
//            } catch DecodingError.keyNotFound(let key, let context) {
//                log.error("==== 🚫 Missing key: \(key)")
//                log.error("==== 🚫 Debug Description: \(context)")
//            } catch DecodingError.valueNotFound(let type, let context) {
//                log.error("==== 🚫 Value of type: \(type) not found")
//                log.error("==== 🚫 Debug Description: \(context)")
//            } catch DecodingError.typeMismatch(let type, let context) {
//                log.error("==== 🚫 Type mismathc for type: \(type)")
//                log.error("==== 🚫 Debug Description: \(context)")
//            } catch {
//                log.error("==== 🚫 \(error.localizedDescription)")
//            }
//
//            guard let respose = apiRespose?.response else { return }
//
//            strongSelf.nextFrom = respose.nextFrom
//
//            let viewModelsForLoadedNews = strongSelf.responseToNewsCellViewModelArray(newsResponse: respose)
//
//            strongSelf.viewModels.append(contentsOf: viewModelsForLoadedNews)
//            DispatchQueue.main.async {
//                strongSelf.delegate?.updateView()
//            }
//        }
    }
/*
    private func responseToNewsCellViewModelArray(newsResponse: NewsResponse) -> [CountryBriefViewModel] {
        var viewModelArray = [CountryBriefViewModel]()
        
        guard let news = newsResponse.news else { return viewModelArray }
        
        // map profiles array to dict
        var profilesDict = [Int:Profile]()
        if let profiles = newsResponse.profiles {
            for profile in profiles {
                profilesDict[profile.id] = profile
            }
        }
        
        // map groups array to dict
        var groupsDict = [Int:Group]()
        if let groups = newsResponse.groups {
            for group in groups {
                groupsDict[group.id] = group
            }
        }
        
        // create aray of News ViewModel
        for (index, item) in news.enumerated() {
            
            guard
                let postId = item.postId,
                let type = item.type,
                let sourceId = item.sourceId
            else {
                log.debug("=== ⏭ skipped news # \(index) type: \(item.type ?? "<nil>")")
                continue
            }
            
            // user name & avatar (depends on source type: profile/group
            var name: String
            var avatarUrl: URL?
            
            if sourceId > 0 {
                // source of post is a prfile (user)
                let profile = profilesDict[sourceId]
                name = "\(profile?.firstName ?? "") \(profile?.lastName ?? "")"
                avatarUrl = profile?.photo100
                
            } else {
                // source of post is a group
                let group = groupsDict[abs(sourceId)]
                name = "\(group?.name ?? "")"
                avatarUrl = group?.photo100
            }
            
            // date
            let dateString = NewsViewModel.dateToStringFormatter.string(from: item.date)
            
            // 1-2 pictures
            var imageUrls = [URL]()
            
            if let photos = item.photos?.items {
                imageUrls = photos.flatMap{$0.photo604}
            }
            
            if let attachments = item.attachments {
                let attachmentImageUrls = attachments
                    .filter{$0.type == "photo"}
                    .flatMap{$0.photo?.photo604} // think about appropriate image size
                imageUrls += attachmentImageUrls
            }
            
            // likes
            let likesCount = item.likes?.count ?? 0
            
            // postId with additional emoji to distinguish popt type: post or photo
            let postIdWithType = "\(postId)" + (type == "post" ? " 📯" : " 🖼") // post : wall_photo
            
            let viewModel = NewsViewModel(
                
                name: name,
                avatarUlr: avatarUrl,
                date: dateString,
                
                imageUlrs: imageUrls,
                
                likesCount: "\(likesCount)",
//                postId: "\(postId)",
                postId: postIdWithType,
                sourceId: "\(sourceId)",
                text: "\(item.text ?? "")")
            
            viewModelArray.append(viewModel)
        }
        return viewModelArray
    }
 */
}
