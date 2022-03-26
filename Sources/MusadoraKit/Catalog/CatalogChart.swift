//
//  CatalogChart.swift
//  CatalogChart
//
//  Created by Rudrank Riyam on 26/03/22.
//

import Foundation
import MusicKit

public protocol MusicCatalogChart {}

extension MusicCatalogChart {
    static var objectIdentifier: ObjectIdentifier {
        ObjectIdentifier(Self.self)
    }
}

extension Song: MusicCatalogChart {}
extension Playlist: MusicCatalogChart {}
extension MusicVideo: MusicCatalogChart {}
extension Album: MusicCatalogChart {}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct Charts: Decodable {
    let results: MusicCatalogChartResponse
}

/// A  chart request that your app uses to fetch charts from the Apple Music catalog
/// using the types of charts and for the genre identifier.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct MusicCatalogChartRequest {
    /// The identifier for the genre to use in the chart results.
    public var genre: MusicItemID?

    /// A limit for the number of items to return
    /// in the catalog chart response.
    public var limit: Int?

    private var types: String

    /// Creates a request to fetch charts using the list of the
    /// types of charts to include in the results.
    public init(for types: [MusicCatalogChart.Type]) {
        self.types = Set(types.map({ $0.objectIdentifier })).compactMap {
            switch $0 {
                case Song.objectIdentifier:
                    return "songs"
                case Album.objectIdentifier:
                    return "albums"
                case MusicVideo.objectIdentifier:
                    return "music-videos"
                case Playlist.objectIdentifier:
                    return "playlists"
                default:
                    return nil
            }
        }.joined(separator: ",")
    }

    /// Fetches charts of the requested catalog chart types that match
    /// the genre ID of the request.
    public func response() async throws -> MusicCatalogChartResponse {
        let url = try await createURL()

        let request = MusicDataRequest(urlRequest: URLRequest(url: url))
        let response = try await request.response()

        let charts = try JSONDecoder().decode(Charts.self, from: response.data)

        return charts.results
    }
}

extension MusicCatalogChartRequest {
    private func createURL() async throws -> URL {
        let storefront = try await MusicDataRequest.currentCountryCode

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.music.apple.com"
        components.path = "/v1/catalog/\(storefront)/charts"

        var queryItems: [URLQueryItem] = []

        queryItems.append(URLQueryItem(name: "types", value: types))

        if let genre = genre {
            queryItems.append(URLQueryItem(name: "genre", value: genre.rawValue))
        }

        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: "\(limit)"))
        }

        components.queryItems = queryItems

        guard let url = components.url else { throw URLError(.badURL) }
        return url
    }
}

/// An object that contains results for a catalog chart request.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct MusicCatalogChartResponse {
    /// An array of collection of songs.
    public let songs: [MusicItemCollection<Song>]

    /// An array of collection of playlists.
    public let playlists: [MusicItemCollection<Playlist>]

    /// An array of collection of music videos.
    public let musicVideos: [MusicItemCollection<MusicVideo>]

    /// An array of collection of albums.
    public let albums: [MusicItemCollection<Album>]
}

extension MusicCatalogChartResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case songs, playlists, albums
        case musicVideos = "music-videos"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        songs = try container.decodeIfPresent([MusicItemCollection<Song>].self, forKey: .songs) ?? []
        playlists = try container.decodeIfPresent([MusicItemCollection<Playlist>].self, forKey: .playlists) ?? []
        musicVideos = try container.decodeIfPresent([MusicItemCollection<MusicVideo>].self, forKey: .musicVideos) ?? []
        albums = try container.decodeIfPresent([MusicItemCollection<Album>].self, forKey: .albums) ?? []
    }
}

extension MusicCatalogChartResponse: Equatable, Hashable {
}