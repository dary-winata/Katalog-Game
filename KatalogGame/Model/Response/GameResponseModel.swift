//
//  GameModel.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 04/11/24.
//

struct GameModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [ListGame]?
}

struct ListGame: Codable {
    let id: Int
    let slug, name, released: String?
    let tba: Bool?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let ratingsCount: Int?
    let reviewsTextCount: Int?
    let added: Int?
    let addedByStatus: AddedByStatus?
    let metacritic: Int?
    let playtime: Int?
    let suggestionCount: Int?
    let updated: String?
    let esrbRating: EsrbRating?
    let platforms: [Platforms]?
    let genres: [Developer]?
    let publishers: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case slug, name, released
        case tba
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic
        case playtime
        case suggestionCount = "suggestion_count"
        case updated
        case esrbRating = "esrb_rating"
        case platforms
        case genres
        case publishers
    }
}

struct Rating: Codable {
    let id: Int
    let title: String
    let count: Int
    let percent: Double
}

struct AddedByStatus: Codable {
    let yet, owned, beaten, toplay: Int?
    let dropped, playing: Int?
}

struct EsrbRating: Codable {
    let id: Int
    let slug: String
    let name: String
}

struct Platforms: Codable {
    let platform: Platform
    let released_at: String?
    let requirements_en: Requirements?
}

struct Requirements: Codable {
    let minimum: String?
    let recommended: String?
}

struct Platform: Codable {
    let id: Int
    let name, slug: String
}
