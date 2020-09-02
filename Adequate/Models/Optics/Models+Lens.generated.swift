// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// Generated with template from:
// https://broomburgo.github.io/fun-ios/post/lenses-and-prisms-in-swift-a-pragmatic-approach/

import Foundation

// MARK: - Deal + Lens
extension Deal {
  enum lens {
    static let id = Lens<Deal, String>(
      get: { $0.id },
      set: { part in 
        { whole in
          Deal.init(id: part, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let dealID = Lens<Deal, String>(
      get: { $0.dealID },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: part, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let title = Lens<Deal, String>(
      get: { $0.title },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: part, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let features = Lens<Deal, String>(
      get: { $0.features },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: part, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let items = Lens<Deal, [Item]>(
      get: { $0.items },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: part, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let photos = Lens<Deal, [URL]>(
      get: { $0.photos },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: part, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let purchaseQuantity = Lens<Deal, PurchaseQuantity?>(
      get: { $0.purchaseQuantity },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: part, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let specifications = Lens<Deal, String>(
      get: { $0.specifications },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: part, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let story = Lens<Deal, Story>(
      get: { $0.story },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: part, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let theme = Lens<Deal, Theme>(
      get: { $0.theme },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: part, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let url = Lens<Deal, URL>(
      get: { $0.url },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: part, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let soldOutAt = Lens<Deal, Date?>(
      get: { $0.soldOutAt },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: part, launches: whole.launches, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let launches = Lens<Deal, [Launch]?>(
      get: { $0.launches },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: part, launchStatus: whole.launchStatus, topic: whole.topic)
        }
      }
    )
    static let launchStatus = Lens<Deal, LaunchStatus?>(
      get: { $0.launchStatus },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: part, topic: whole.topic)
        }
      }
    )
    static let topic = Lens<Deal, Topic?>(
      get: { $0.topic },
      set: { part in 
        { whole in
          Deal.init(id: whole.id, dealID: whole.dealID, title: whole.title, features: whole.features, items: whole.items, photos: whole.photos, purchaseQuantity: whole.purchaseQuantity, specifications: whole.specifications, story: whole.story, theme: whole.theme, url: whole.url, soldOutAt: whole.soldOutAt, launches: whole.launches, launchStatus: whole.launchStatus, topic: part)
        }
      }
    )
  }
}

// MARK: - Topic + Lens
extension Topic {
  enum lens {
    static let commentCount = Lens<Topic, Int>(
      get: { $0.commentCount },
      set: { part in 
        { whole in
          Topic.init(commentCount: part, createdAt: whole.createdAt, id: whole.id, replyCount: whole.replyCount, url: whole.url, voteCount: whole.voteCount)
        }
      }
    )
    static let createdAt = Lens<Topic, Date>(
      get: { $0.createdAt },
      set: { part in 
        { whole in
          Topic.init(commentCount: whole.commentCount, createdAt: part, id: whole.id, replyCount: whole.replyCount, url: whole.url, voteCount: whole.voteCount)
        }
      }
    )
    static let id = Lens<Topic, String>(
      get: { $0.id },
      set: { part in 
        { whole in
          Topic.init(commentCount: whole.commentCount, createdAt: whole.createdAt, id: part, replyCount: whole.replyCount, url: whole.url, voteCount: whole.voteCount)
        }
      }
    )
    static let replyCount = Lens<Topic, Int>(
      get: { $0.replyCount },
      set: { part in 
        { whole in
          Topic.init(commentCount: whole.commentCount, createdAt: whole.createdAt, id: whole.id, replyCount: part, url: whole.url, voteCount: whole.voteCount)
        }
      }
    )
    static let url = Lens<Topic, URL>(
      get: { $0.url },
      set: { part in 
        { whole in
          Topic.init(commentCount: whole.commentCount, createdAt: whole.createdAt, id: whole.id, replyCount: whole.replyCount, url: part, voteCount: whole.voteCount)
        }
      }
    )
    static let voteCount = Lens<Topic, Int>(
      get: { $0.voteCount },
      set: { part in 
        { whole in
          Topic.init(commentCount: whole.commentCount, createdAt: whole.createdAt, id: whole.id, replyCount: whole.replyCount, url: whole.url, voteCount: part)
        }
      }
    )
  }
}

