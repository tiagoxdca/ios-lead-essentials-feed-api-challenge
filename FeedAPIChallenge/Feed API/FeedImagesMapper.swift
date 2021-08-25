//
//  FeedImagesMapper.swift
//  FeedAPIChallenge
//
//  Created by Tiago Xavier da Cunha Almeida on 25/08/2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

struct FeedImagesMapper {
	private struct Root: Decodable {
		let items: [Image]
	}

	private struct Image: Decodable {
		let image_id: UUID
		let image_desc: String?
		let image_loc: String?
		let image_url: URL

		var image: FeedImage {
			FeedImage(id: image_id, description: image_desc, location: image_loc, url: image_url)
		}
	}

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedImage] {
		guard response.statusCode == 200 else {
			throw RemoteFeedLoader.Error.invalidData
		}

		return try JSONDecoder().decode(Root.self, from: data).items.map { $0.image }
	}
}
