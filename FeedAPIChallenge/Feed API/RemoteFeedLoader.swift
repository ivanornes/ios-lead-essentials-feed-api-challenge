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
		client.get(from: url) { result in
			do {
				switch result {
				case .success((let data, let response)):
					if response.statusCode == 200 {
						let images = try RemoteImagesLoader.getImages(data)
						completion(.success(images))
					} else {
						completion(.failure(Error.invalidData))
					}
				case .failure(_): completion(.failure(Error.connectivity))
				}
			} catch {
				completion(.failure(Error.invalidData))
			}
		}
	}
}
