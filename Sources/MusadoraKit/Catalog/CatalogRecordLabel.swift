//
//  CatalogRecordLabel.swift
//  CatalogRecordLabel
//
//  Created by Rudrank Riyam on 10/04/22.
//

import MusicKit

/// A collection of record labels.
public typealias RecordLabels = MusicItemCollection<RecordLabel>

/// Additional property/relationship of a record label.
public typealias RecordLabelProperty = PartialMusicAsyncProperty<RecordLabel>

/// Additional properties/relationships of a record label.
public typealias RecordLabelProperties = [RecordLabelProperty]

public extension MusadoraKit {
  /// Fetch a record label from the Apple Music catalog by using its identifier.
  /// - Parameters:
  ///   - id: The unique identifier for the record label.
  ///   - properties: Additional relationships to fetch with the record label.
  /// - Returns: `RecordLabel` matching the given identifier.
  static func catalogRecordLabel(id: MusicItemID, with properties: RecordLabelProperties = []) async throws -> RecordLabel {
    var request = MusicCatalogResourceRequest<RecordLabel>(matching: \.id, equalTo: id)
    request.properties = properties
    let response = try await request.response()

    guard let recordLabel = response.items.first else {
      throw MusadoraKitError.notFound(for: id.rawValue)
    }
    return recordLabel
  }

#if compiler(>=5.7)
  /// Fetch a record label from the Apple Music catalog by using its identifier with all properties.
  /// - Parameters:
  ///   - id: The unique identifier for the record label.
  /// - Returns: `RecordLabel` matching the given identifier.
  static func catalogRecordLabel(id: MusicItemID) async throws -> RecordLabel {
    var request = MusicCatalogResourceRequest<RecordLabel>(matching: \.id, equalTo: id)
    request.properties = .all
    let response = try await request.response()

    guard let recordLabel = response.items.first else {
      throw MusadoraKitError.notFound(for: id.rawValue)
    }
    return recordLabel
  }
#endif

  /// Fetch multiple record labels from the Apple Music catalog by using their identifiers.
  /// - Parameters:
  ///   - ids: The unique identifiers for the record labels.
  ///   - properties: Additional relationships to fetch with the record labels.
  /// - Returns: `RecordLabels` matching the given identifiers.
  static func catalogRecordLabels(ids: [MusicItemID], with properties: RecordLabelProperties = []) async throws -> RecordLabels {
    var request = MusicCatalogResourceRequest<RecordLabel>(matching: \.id, memberOf: ids)
    request.properties = properties
    let response = try await request.response()
    return response.items
  }

#if compiler(>=5.7)
  /// Fetch multiple record labels from the Apple Music catalog by using their identifiers with all properties.
  /// - Parameters:
  ///   - ids: The unique identifiers for the record labels.
  /// - Returns: `RecordLabels` matching the given identifiers.
  static func catalogRecordLabels(ids: [MusicItemID]) async throws -> RecordLabels {
    var request = MusicCatalogResourceRequest<RecordLabel>(matching: \.id, memberOf: ids)
    request.properties = .all
    let response = try await request.response()
    return response.items
  }
#endif
}

#if compiler(>=5.7)
extension Array where Element == RecordLabelProperty {
  public static var all: Self {
    [.latestReleases, .topReleases]
  }
}
#endif
