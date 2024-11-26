//
//  GameDetailModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 06/11/24.
//

struct GameDetailModel: Codable {
    let id: Int
    let slug: String
    let name: String
    let nameOriginal: String
    let metacritic: Int?
    let metacriticPlatforms: [MetacriticPlatformModel]?
    let released: String?
    let tba: Bool?
    let updated: String?
    let backgroundImage: String?
    let backgroundImageAdditional: String?
    let website: String?
    let rating: Double
    let ratingTop: Double
    let ratings: [Rating]
    let reactions: [String: Int]?
    let added: Int
    let addedByStatus: AddedByStatus?
    let playtime, screenshotsCount, moviesCount, creatorsCount: Int?
    let achievementsCount, parentAchievementsCount: Int?
    let redditURL: String?
    let redditName, redditDescription, redditLogo: String?
    let redditCount, twitchCount, youtubeCount, reviewsTextCount: Int?
    let ratingsCount, suggestionsCount: Int?
    let alternativeNames: [String]?
    let metacriticURL: String?
    let parentsCount, additionsCount, gameSeriesCount: Int?
    let reviewsCount: Int?
    let saturatedColor, dominantColor: String?
    let parentPlatforms: [ParentPlatform]?
    let platforms: [PlatformElement]?
    let stores: [Store]?
    let developers, genres, tags, publishers: [Developer]?
    let esrbRating: EsrbRating?
    let descriptionRaw: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case nameOriginal = "name_original"
        case metacritic
        case metacriticPlatforms = "metacritic_platforms"
        case released
        case tba
        case updated
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case website
        case rating
        case ratingTop = "rating_top"
        case ratings
        case reactions
        case added
        case addedByStatus
        case playtime, screenshotsCount, moviesCount, creatorsCount
        case achievementsCount, parentAchievementsCount
        case redditURL
        case redditName, redditDescription, redditLogo
        case redditCount, twitchCount, youtubeCount, reviewsTextCount
        case ratingsCount, suggestionsCount
        case alternativeNames
        case metacriticURL
        case parentsCount, additionsCount, gameSeriesCount
        case reviewsCount
        case saturatedColor, dominantColor
        case parentPlatforms
        case platforms
        case stores
        case developers, genres, tags, publishers
        case esrbRating
        case descriptionRaw = "description_raw"
    }
}

struct MetacriticPlatformModel: Codable {
    let metascore: Int?
    let url: String?
}

struct ParentPlatform: Codable {
    let platform: EsrbRating?
}

struct PlatformElement: Codable {
    let platform: GamePlatform?
    let releasedAt: String?
    let requirements: Requirements?
}

struct Developer: Codable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let domain: String?
    let language: String?
}

struct Store: Codable {
    let id: Int?
    let url: String?
    let store: Developer?
}

struct GamePlatform: Codable {
    let id: Int?
    let name, slug: String?
    let image: String?
    let yearEnd, yearStart: Int?
    let gamesCount: Int?
    let imageBackground: String?
}
