//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		client.get(from: url) { [weak self] result in
			guard self != nil else { return }
			switch result {
			case let .success((data, response)):
				guard let images = try? FeedImagesMapper.map(data, response) else {
					completion(.failure(Error.invalidData))
					return
				}
				completion(.success(images))
			default:
				completion(.failure(Error.connectivity))
			}
		}
	}

	private struct Root: Decodable {
		let items: [FeedItemAPI]
	}

	private struct FeedItemAPI: Decodable {
		let image_id: String
		let image_desc: String
		let image_loc: String
		let image_url: URL
	}
}
