# MusadoraKit

The ultimate companion to MusicKit.

<p align="center">
  <img src= "https://github.com/rryam/MusadoraKit/blob/main/MusadoraKitIcon.png" alt="MusadoraKit Logo" width="256"/>
</p>

![Twitter Follow](https://img.shields.io/twitter/follow/rudrankriyam?style=social)

MusadoraKit is a Swift framework that uses the latest MusicKit and Apple Music API, making it easy to integrate Apple Music into your app. It uses the new async/await pattern introduced in Swift 5.5. Currently, it is available for iOS 15.0+, macOS 12.0+, watchOS 8.0+ and tvOS 15.0+.

It goes well with my book on [*Exploring MusicKit and Apple Music API*](http://exploringmusickit.com), as all the documentation and references are mentioned in the book. Otherwise, the code itself is well documented.

## Support 

You can support my open-source by buying my book, ["Exploring MusicKit and Apple Music API"](exploringmusickit.com) or by [buying me a book](https://www.buymeacoffee.com/rudrank)! 

## Catalog 

To easily access the Apple Music Catalog, you can use pre-defined methods from MusadoraKit. The method are similar across the music items. 

Example of working with fetching a catalog song by its identifier: 

```swift 
let song = try await MusadoraKit.catalogSong(id: "1613834314", with: [.albums])
```

Example of searching the catalog: 

```swift 
let searchResponse = try await MusadoraKit.catalogSearch(for: "weeknd", types: [Song.self, Artist.self])

print(searchResponse.songs)
print(searchResponse.artists)
```

## Library 

While this is natively not available in MusicKit, you can fetch library resources using MusadoraKit that uses Apple Music API under the hood. The method are similar across the music items. 

Example of fetching all library songs in alphabetical order: 

```swift 
let songs = try await MusadoraKit.librarySongs()
```

Example of searching the user's library: 

```swift 
let searchResponse = try await MusadoraKit.librarySearch(for: "hello", types: [Song.self])

print(searchResponse.songs)
```

## Recommendations 

You can take advantage of Apple's Music recommendation system and use it in your app. For example, to fetch the default recommendations: 

```swift 
let recommendations = try await MusadoraKit.recommendations()

guard let recommendation = recommendations.first else { return }

print(recommendation.albums)
print(recommendation.playlists)
print(recommendation.stations)
```

## History 

You can also fetch historial data from the user's library. For example, to get the recently played resources: 

```swift 
let recentlyPlayedItems = try await MusadoraKit.recentlyPlayed()

let recentlyPlayedAlbums: [Album] = recentlyPlayedItems.compactMap { item in
    guard case let .album(album) = item else { return nil }
    return album
}
```

## MusicCatalogResourcesRequest: 

To fetch multiple catalog music items by their identifiers in the same request. For example:

```swift 
let request = MusicCatalogResourcesRequest(types: [.songs: ["1456313177"], .albums: ["1531125029", "1575203352"]])
let response = try await request.response()

print(response.songs)
print(response.albums)
```

## MusicLibraryResourcesRequest:

To fetch multiple library music items by their identifiers in the same request. For example:

```swift
let request = MusicLibraryResourcesRequest(types: [.songs: ["i.pmzqzM0S2rl5N4L"], .playlists: ["p.PkxVBgps2zOdV3r"]])
let response = try await request.response()

print(response.songs)
print(response.playlists)
```

## Ratings 

To add ratings to a music item, use the following structure: 

```swift 
let id: MusicItemID = "1628890886"
let request = MusicCatalogRatingAddRequest<Song>(matching: \.id, equalTo: id, rating: .loved)
let response = try await request.response()

print(response.items)
```

I hope you love working with MusadoraKit! 
