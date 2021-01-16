//  This file was automatically generated and should not be edited.

import AWSAppSync
// swiftlint:disable all
public struct CreateDealInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, dealId: GraphQLID? = nil, title: String, features: String, specifications: String, url: String, createdAt: String? = nil, endDate: String? = nil, soldOutAt: String? = nil, items: [ItemInput], modelNumbers: [String]? = nil, photos: [String], story: StoryInput? = nil, topic: TopicInput? = nil, theme: ThemeInput, purchaseQuantity: PurchaseQuantityInput? = nil, launches: [LaunchInput]? = nil, launchStatus: LaunchStatus, version: Int? = nil) {
    graphQLMap = ["id": id, "dealID": dealId, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items, "modelNumbers": modelNumbers, "photos": photos, "story": story, "topic": topic, "theme": theme, "purchaseQuantity": purchaseQuantity, "launches": launches, "launchStatus": launchStatus, "_version": version]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var dealId: GraphQLID? {
    get {
      return graphQLMap["dealID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealID")
    }
  }

  public var title: String {
    get {
      return graphQLMap["title"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var features: String {
    get {
      return graphQLMap["features"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "features")
    }
  }

  public var specifications: String {
    get {
      return graphQLMap["specifications"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "specifications")
    }
  }

  public var url: String {
    get {
      return graphQLMap["url"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var endDate: String? {
    get {
      return graphQLMap["endDate"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "endDate")
    }
  }

  public var soldOutAt: String? {
    get {
      return graphQLMap["soldOutAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "soldOutAt")
    }
  }

  public var items: [ItemInput] {
    get {
      return graphQLMap["items"] as! [ItemInput]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "items")
    }
  }

  public var modelNumbers: [String]? {
    get {
      return graphQLMap["modelNumbers"] as! [String]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "modelNumbers")
    }
  }

  public var photos: [String] {
    get {
      return graphQLMap["photos"] as! [String]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "photos")
    }
  }

  public var story: StoryInput? {
    get {
      return graphQLMap["story"] as! StoryInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "story")
    }
  }

  public var topic: TopicInput? {
    get {
      return graphQLMap["topic"] as! TopicInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "topic")
    }
  }

  public var theme: ThemeInput {
    get {
      return graphQLMap["theme"] as! ThemeInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "theme")
    }
  }

  public var purchaseQuantity: PurchaseQuantityInput? {
    get {
      return graphQLMap["purchaseQuantity"] as! PurchaseQuantityInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "purchaseQuantity")
    }
  }

  public var launches: [LaunchInput]? {
    get {
      return graphQLMap["launches"] as! [LaunchInput]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "launches")
    }
  }

  public var launchStatus: LaunchStatus {
    get {
      return graphQLMap["launchStatus"] as! LaunchStatus
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "launchStatus")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct ItemInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, attributes: [ItemAttributeInput?], condition: String, price: Double, photo: String) {
    graphQLMap = ["id": id, "attributes": attributes, "condition": condition, "price": price, "photo": photo]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var attributes: [ItemAttributeInput?] {
    get {
      return graphQLMap["attributes"] as! [ItemAttributeInput?]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributes")
    }
  }

  public var condition: String {
    get {
      return graphQLMap["condition"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "condition")
    }
  }

  public var price: Double {
    get {
      return graphQLMap["price"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "price")
    }
  }

  public var photo: String {
    get {
      return graphQLMap["photo"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "photo")
    }
  }
}

public struct ItemAttributeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(key: String, value: String) {
    graphQLMap = ["key": key, "value": value]
  }

  public var key: String {
    get {
      return graphQLMap["key"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "key")
    }
  }

  public var value: String {
    get {
      return graphQLMap["value"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "value")
    }
  }
}

public struct StoryInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(title: String, body: String) {
    graphQLMap = ["title": title, "body": body]
  }

  public var title: String {
    get {
      return graphQLMap["title"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var body: String {
    get {
      return graphQLMap["body"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "body")
    }
  }
}

public struct TopicInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
    graphQLMap = ["id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var commentCount: Int {
    get {
      return graphQLMap["commentCount"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "commentCount")
    }
  }

  public var createdAt: String {
    get {
      return graphQLMap["createdAt"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var replyCount: Int {
    get {
      return graphQLMap["replyCount"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "replyCount")
    }
  }

  public var url: String {
    get {
      return graphQLMap["url"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }

  public var voteCount: Int {
    get {
      return graphQLMap["voteCount"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "voteCount")
    }
  }
}

public struct ThemeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
    graphQLMap = ["accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground]
  }

  public var accentColor: String {
    get {
      return graphQLMap["accentColor"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "accentColor")
    }
  }

  public var backgroundColor: String {
    get {
      return graphQLMap["backgroundColor"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "backgroundColor")
    }
  }

  public var backgroundImage: String? {
    get {
      return graphQLMap["backgroundImage"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "backgroundImage")
    }
  }

  public var foreground: ThemeForeground {
    get {
      return graphQLMap["foreground"] as! ThemeForeground
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "foreground")
    }
  }
}

public enum ThemeForeground: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case dark
  case light
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "dark": self = .dark
      case "light": self = .light
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .dark: return "dark"
      case .light: return "light"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ThemeForeground, rhs: ThemeForeground) -> Bool {
    switch (lhs, rhs) {
      case (.dark, .dark): return true
      case (.light, .light): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct PurchaseQuantityInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(maximumLimit: Int, minimumLimit: Int) {
    graphQLMap = ["maximumLimit": maximumLimit, "minimumLimit": minimumLimit]
  }

  public var maximumLimit: Int {
    get {
      return graphQLMap["maximumLimit"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "maximumLimit")
    }
  }

  public var minimumLimit: Int {
    get {
      return graphQLMap["minimumLimit"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "minimumLimit")
    }
  }
}

public struct LaunchInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(soldOutAt: String? = nil) {
    graphQLMap = ["soldOutAt": soldOutAt]
  }

  public var soldOutAt: String? {
    get {
      return graphQLMap["soldOutAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "soldOutAt")
    }
  }
}

public enum LaunchStatus: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case launch
  case launchSoldOut
  case relaunch
  case relaunchSoldOut
  case reserve
  case soldOut
  case expired
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "launch": self = .launch
      case "launchSoldOut": self = .launchSoldOut
      case "relaunch": self = .relaunch
      case "relaunchSoldOut": self = .relaunchSoldOut
      case "reserve": self = .reserve
      case "soldOut": self = .soldOut
      case "expired": self = .expired
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .launch: return "launch"
      case .launchSoldOut: return "launchSoldOut"
      case .relaunch: return "relaunch"
      case .relaunchSoldOut: return "relaunchSoldOut"
      case .reserve: return "reserve"
      case .soldOut: return "soldOut"
      case .expired: return "expired"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: LaunchStatus, rhs: LaunchStatus) -> Bool {
    switch (lhs, rhs) {
      case (.launch, .launch): return true
      case (.launchSoldOut, .launchSoldOut): return true
      case (.relaunch, .relaunch): return true
      case (.relaunchSoldOut, .relaunchSoldOut): return true
      case (.reserve, .reserve): return true
      case (.soldOut, .soldOut): return true
      case (.expired, .expired): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelDealConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(dealId: ModelIDInput? = nil, dealYear: ModelStringInput? = nil, monthDay: ModelStringInput? = nil, title: ModelStringInput? = nil, features: ModelStringInput? = nil, specifications: ModelStringInput? = nil, url: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, endDate: ModelStringInput? = nil, soldOutAt: ModelStringInput? = nil, modelNumbers: ModelStringInput? = nil, photos: ModelStringInput? = nil, launchStatus: ModelLaunchStatusInput? = nil, and: [ModelDealConditionInput?]? = nil, or: [ModelDealConditionInput?]? = nil, not: ModelDealConditionInput? = nil) {
    graphQLMap = ["dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "modelNumbers": modelNumbers, "photos": photos, "launchStatus": launchStatus, "and": and, "or": or, "not": not]
  }

  public var dealId: ModelIDInput? {
    get {
      return graphQLMap["dealID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealID")
    }
  }

  public var dealYear: ModelStringInput? {
    get {
      return graphQLMap["dealYear"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealYear")
    }
  }

  public var monthDay: ModelStringInput? {
    get {
      return graphQLMap["monthDay"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "monthDay")
    }
  }

  public var title: ModelStringInput? {
    get {
      return graphQLMap["title"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var features: ModelStringInput? {
    get {
      return graphQLMap["features"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "features")
    }
  }

  public var specifications: ModelStringInput? {
    get {
      return graphQLMap["specifications"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "specifications")
    }
  }

  public var url: ModelStringInput? {
    get {
      return graphQLMap["url"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var endDate: ModelStringInput? {
    get {
      return graphQLMap["endDate"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "endDate")
    }
  }

  public var soldOutAt: ModelStringInput? {
    get {
      return graphQLMap["soldOutAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "soldOutAt")
    }
  }

  public var modelNumbers: ModelStringInput? {
    get {
      return graphQLMap["modelNumbers"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "modelNumbers")
    }
  }

  public var photos: ModelStringInput? {
    get {
      return graphQLMap["photos"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "photos")
    }
  }

  public var launchStatus: ModelLaunchStatusInput? {
    get {
      return graphQLMap["launchStatus"] as! ModelLaunchStatusInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "launchStatus")
    }
  }

  public var and: [ModelDealConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelDealConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelDealConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelDealConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelDealConditionInput? {
    get {
      return graphQLMap["not"] as! ModelDealConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public enum ModelAttributeTypes: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case binary
  case binarySet
  case bool
  case list
  case map
  case number
  case numberSet
  case string
  case stringSet
  case null
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "binary": self = .binary
      case "binarySet": self = .binarySet
      case "bool": self = .bool
      case "list": self = .list
      case "map": self = .map
      case "number": self = .number
      case "numberSet": self = .numberSet
      case "string": self = .string
      case "stringSet": self = .stringSet
      case "_null": self = .null
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .binary: return "binary"
      case .binarySet: return "binarySet"
      case .bool: return "bool"
      case .list: return "list"
      case .map: return "map"
      case .number: return "number"
      case .numberSet: return "numberSet"
      case .string: return "string"
      case .stringSet: return "stringSet"
      case .null: return "_null"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelAttributeTypes, rhs: ModelAttributeTypes) -> Bool {
    switch (lhs, rhs) {
      case (.binary, .binary): return true
      case (.binarySet, .binarySet): return true
      case (.bool, .bool): return true
      case (.list, .list): return true
      case (.map, .map): return true
      case (.number, .number): return true
      case (.numberSet, .numberSet): return true
      case (.string, .string): return true
      case (.stringSet, .stringSet): return true
      case (.null, .null): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelSizeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public struct ModelStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct ModelLaunchStatusInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: LaunchStatus? = nil, ne: LaunchStatus? = nil) {
    graphQLMap = ["eq": eq, "ne": ne]
  }

  public var eq: LaunchStatus? {
    get {
      return graphQLMap["eq"] as! LaunchStatus?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var ne: LaunchStatus? {
    get {
      return graphQLMap["ne"] as! LaunchStatus?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }
}

public struct UpdateDealInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, dealId: GraphQLID? = nil, dealYear: String? = nil, monthDay: String? = nil, title: String? = nil, features: String? = nil, specifications: String? = nil, url: String? = nil, createdAt: String? = nil, endDate: String? = nil, soldOutAt: String? = nil, items: [ItemInput]? = nil, modelNumbers: [String]? = nil, photos: [String]? = nil, story: StoryInput? = nil, topic: TopicInput? = nil, theme: ThemeInput? = nil, purchaseQuantity: PurchaseQuantityInput? = nil, launches: [LaunchInput]? = nil, launchStatus: LaunchStatus? = nil, version: Int? = nil) {
    graphQLMap = ["id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items, "modelNumbers": modelNumbers, "photos": photos, "story": story, "topic": topic, "theme": theme, "purchaseQuantity": purchaseQuantity, "launches": launches, "launchStatus": launchStatus, "_version": version]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var dealId: GraphQLID? {
    get {
      return graphQLMap["dealID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealID")
    }
  }

  public var dealYear: String? {
    get {
      return graphQLMap["dealYear"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealYear")
    }
  }

  public var monthDay: String? {
    get {
      return graphQLMap["monthDay"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "monthDay")
    }
  }

  public var title: String? {
    get {
      return graphQLMap["title"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var features: String? {
    get {
      return graphQLMap["features"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "features")
    }
  }

  public var specifications: String? {
    get {
      return graphQLMap["specifications"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "specifications")
    }
  }

  public var url: String? {
    get {
      return graphQLMap["url"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var endDate: String? {
    get {
      return graphQLMap["endDate"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "endDate")
    }
  }

  public var soldOutAt: String? {
    get {
      return graphQLMap["soldOutAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "soldOutAt")
    }
  }

  public var items: [ItemInput]? {
    get {
      return graphQLMap["items"] as! [ItemInput]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "items")
    }
  }

  public var modelNumbers: [String]? {
    get {
      return graphQLMap["modelNumbers"] as! [String]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "modelNumbers")
    }
  }

  public var photos: [String]? {
    get {
      return graphQLMap["photos"] as! [String]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "photos")
    }
  }

  public var story: StoryInput? {
    get {
      return graphQLMap["story"] as! StoryInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "story")
    }
  }

  public var topic: TopicInput? {
    get {
      return graphQLMap["topic"] as! TopicInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "topic")
    }
  }

  public var theme: ThemeInput? {
    get {
      return graphQLMap["theme"] as! ThemeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "theme")
    }
  }

  public var purchaseQuantity: PurchaseQuantityInput? {
    get {
      return graphQLMap["purchaseQuantity"] as! PurchaseQuantityInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "purchaseQuantity")
    }
  }

  public var launches: [LaunchInput]? {
    get {
      return graphQLMap["launches"] as! [LaunchInput]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "launches")
    }
  }

  public var launchStatus: LaunchStatus? {
    get {
      return graphQLMap["launchStatus"] as! LaunchStatus?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "launchStatus")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct DeleteDealInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, version: Int? = nil) {
    graphQLMap = ["id": id, "_version": version]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var version: Int? {
    get {
      return graphQLMap["_version"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "_version")
    }
  }
}

public struct DealHistoryFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: CustomIDFilterInput? = nil, dealId: CustomIDFilterInput? = nil, dealYear: CustomStringFilterInput? = nil, monthDay: CustomStringFilterInput? = nil, title: CustomStringFilterInput? = nil, features: CustomStringFilterInput? = nil, specifications: CustomStringFilterInput? = nil, url: CustomStringFilterInput? = nil, createdAt: CustomStringFilterInput? = nil, endDate: CustomStringFilterInput? = nil, soldOutAt: CustomStringFilterInput? = nil, modelNumbers: CustomStringFilterInput? = nil, photos: CustomStringFilterInput? = nil, launchStatus: CustomLaunchStatusInput? = nil, and: [DealHistoryFilterInput?]? = nil, or: [DealHistoryFilterInput?]? = nil, not: DealHistoryFilterInput? = nil) {
    graphQLMap = ["id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "modelNumbers": modelNumbers, "photos": photos, "launchStatus": launchStatus, "and": and, "or": or, "not": not]
  }

  public var id: CustomIDFilterInput? {
    get {
      return graphQLMap["id"] as! CustomIDFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var dealId: CustomIDFilterInput? {
    get {
      return graphQLMap["dealID"] as! CustomIDFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealID")
    }
  }

  public var dealYear: CustomStringFilterInput? {
    get {
      return graphQLMap["dealYear"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealYear")
    }
  }

  public var monthDay: CustomStringFilterInput? {
    get {
      return graphQLMap["monthDay"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "monthDay")
    }
  }

  public var title: CustomStringFilterInput? {
    get {
      return graphQLMap["title"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var features: CustomStringFilterInput? {
    get {
      return graphQLMap["features"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "features")
    }
  }

  public var specifications: CustomStringFilterInput? {
    get {
      return graphQLMap["specifications"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "specifications")
    }
  }

  public var url: CustomStringFilterInput? {
    get {
      return graphQLMap["url"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }

  public var createdAt: CustomStringFilterInput? {
    get {
      return graphQLMap["createdAt"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var endDate: CustomStringFilterInput? {
    get {
      return graphQLMap["endDate"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "endDate")
    }
  }

  public var soldOutAt: CustomStringFilterInput? {
    get {
      return graphQLMap["soldOutAt"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "soldOutAt")
    }
  }

  public var modelNumbers: CustomStringFilterInput? {
    get {
      return graphQLMap["modelNumbers"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "modelNumbers")
    }
  }

  public var photos: CustomStringFilterInput? {
    get {
      return graphQLMap["photos"] as! CustomStringFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "photos")
    }
  }

  public var launchStatus: CustomLaunchStatusInput? {
    get {
      return graphQLMap["launchStatus"] as! CustomLaunchStatusInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "launchStatus")
    }
  }

  public var and: [DealHistoryFilterInput?]? {
    get {
      return graphQLMap["and"] as! [DealHistoryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [DealHistoryFilterInput?]? {
    get {
      return graphQLMap["or"] as! [DealHistoryFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: DealHistoryFilterInput? {
    get {
      return graphQLMap["not"] as! DealHistoryFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct CustomIDFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

public struct CustomStringFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

public struct CustomLaunchStatusInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: LaunchStatus? = nil, ne: LaunchStatus? = nil) {
    graphQLMap = ["eq": eq, "ne": ne]
  }

  public var eq: LaunchStatus? {
    get {
      return graphQLMap["eq"] as! LaunchStatus?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var ne: LaunchStatus? {
    get {
      return graphQLMap["ne"] as! LaunchStatus?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }
}

public struct ModelDealFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, dealId: ModelIDInput? = nil, dealYear: ModelStringInput? = nil, monthDay: ModelStringInput? = nil, title: ModelStringInput? = nil, features: ModelStringInput? = nil, specifications: ModelStringInput? = nil, url: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, endDate: ModelStringInput? = nil, soldOutAt: ModelStringInput? = nil, modelNumbers: ModelStringInput? = nil, photos: ModelStringInput? = nil, launchStatus: ModelLaunchStatusInput? = nil, and: [ModelDealFilterInput?]? = nil, or: [ModelDealFilterInput?]? = nil, not: ModelDealFilterInput? = nil) {
    graphQLMap = ["id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "modelNumbers": modelNumbers, "photos": photos, "launchStatus": launchStatus, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var dealId: ModelIDInput? {
    get {
      return graphQLMap["dealID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealID")
    }
  }

  public var dealYear: ModelStringInput? {
    get {
      return graphQLMap["dealYear"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dealYear")
    }
  }

  public var monthDay: ModelStringInput? {
    get {
      return graphQLMap["monthDay"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "monthDay")
    }
  }

  public var title: ModelStringInput? {
    get {
      return graphQLMap["title"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var features: ModelStringInput? {
    get {
      return graphQLMap["features"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "features")
    }
  }

  public var specifications: ModelStringInput? {
    get {
      return graphQLMap["specifications"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "specifications")
    }
  }

  public var url: ModelStringInput? {
    get {
      return graphQLMap["url"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "url")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var endDate: ModelStringInput? {
    get {
      return graphQLMap["endDate"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "endDate")
    }
  }

  public var soldOutAt: ModelStringInput? {
    get {
      return graphQLMap["soldOutAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "soldOutAt")
    }
  }

  public var modelNumbers: ModelStringInput? {
    get {
      return graphQLMap["modelNumbers"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "modelNumbers")
    }
  }

  public var photos: ModelStringInput? {
    get {
      return graphQLMap["photos"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "photos")
    }
  }

  public var launchStatus: ModelLaunchStatusInput? {
    get {
      return graphQLMap["launchStatus"] as! ModelLaunchStatusInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "launchStatus")
    }
  }

  public var and: [ModelDealFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelDealFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelDealFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelDealFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelDealFilterInput? {
    get {
      return graphQLMap["not"] as! ModelDealFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelStringKeyConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, between: [String?]? = nil, beginsWith: String? = nil) {
    graphQLMap = ["eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "beginsWith": beginsWith]
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }
}

public enum ModelSortDirection: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case asc
  case desc
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ASC": self = .asc
      case "DESC": self = .desc
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .asc: return "ASC"
      case .desc: return "DESC"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelSortDirection, rhs: ModelSortDirection) -> Bool {
    switch (lhs, rhs) {
      case (.asc, .asc): return true
      case (.desc, .desc): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public final class CreateDealMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateDeal($input: CreateDealInput!, $condition: ModelDealConditionInput) {\n  createDeal(input: $input, condition: $condition) {\n    __typename\n    id\n    dealID\n    dealYear\n    monthDay\n    title\n    features\n    specifications\n    url\n    createdAt\n    endDate\n    soldOutAt\n    items {\n      __typename\n      id\n      attributes {\n        __typename\n        key\n        value\n      }\n      condition\n      price\n      photo\n    }\n    modelNumbers\n    photos\n    story {\n      __typename\n      title\n      body\n    }\n    topic {\n      __typename\n      id\n      commentCount\n      createdAt\n      replyCount\n      url\n      voteCount\n    }\n    theme {\n      __typename\n      accentColor\n      backgroundColor\n      backgroundImage\n      foreground\n    }\n    purchaseQuantity {\n      __typename\n      maximumLimit\n      minimumLimit\n    }\n    launches {\n      __typename\n      soldOutAt\n    }\n    launchStatus\n    _version\n    _deleted\n    _lastChangedAt\n    updatedAt\n  }\n}"

  public var input: CreateDealInput
  public var condition: ModelDealConditionInput?

  public init(input: CreateDealInput, condition: ModelDealConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createDeal", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createDeal: CreateDeal? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createDeal": createDeal.flatMap { $0.snapshot }])
    }

    public var createDeal: CreateDeal? {
      get {
        return (snapshot["createDeal"] as? Snapshot).flatMap { CreateDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createDeal")
      }
    }

    public struct CreateDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["Deal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
        GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("features", type: .nonNull(.scalar(String.self))),
        GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("endDate", type: .scalar(String.self)),
        GraphQLField("soldOutAt", type: .scalar(String.self)),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("story", type: .object(Story.selections)),
        GraphQLField("topic", type: .object(Topic.selections)),
        GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
        GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
        GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
        GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
        self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var dealId: GraphQLID {
        get {
          return snapshot["dealID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealID")
        }
      }

      public var dealYear: String {
        get {
          return snapshot["dealYear"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealYear")
        }
      }

      public var monthDay: String {
        get {
          return snapshot["monthDay"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "monthDay")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var features: String {
        get {
          return snapshot["features"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "features")
        }
      }

      public var specifications: String {
        get {
          return snapshot["specifications"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "specifications")
        }
      }

      public var url: String {
        get {
          return snapshot["url"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var endDate: String? {
        get {
          return snapshot["endDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "endDate")
        }
      }

      public var soldOutAt: String? {
        get {
          return snapshot["soldOutAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "soldOutAt")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var modelNumbers: [String]? {
        get {
          return snapshot["modelNumbers"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "modelNumbers")
        }
      }

      public var photos: [String] {
        get {
          return snapshot["photos"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "photos")
        }
      }

      public var story: Story? {
        get {
          return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "story")
        }
      }

      public var topic: Topic? {
        get {
          return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "topic")
        }
      }

      public var theme: Theme {
        get {
          return Theme(snapshot: snapshot["theme"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "theme")
        }
      }

      public var purchaseQuantity: PurchaseQuantity? {
        get {
          return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
        }
      }

      public var launches: [Launch]? {
        get {
          return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
        }
      }

      public var launchStatus: LaunchStatus {
        get {
          return snapshot["launchStatus"]! as! LaunchStatus
        }
        set {
          snapshot.updateValue(newValue, forKey: "launchStatus")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Item"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("attributes", type: .nonNull(.list(.object(Attribute.selections)))),
          GraphQLField("condition", type: .nonNull(.scalar(String.self))),
          GraphQLField("price", type: .nonNull(.scalar(Double.self))),
          GraphQLField("photo", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, attributes: [Attribute?], condition: String, price: Double, photo: String) {
          self.init(snapshot: ["__typename": "Item", "id": id, "attributes": attributes.map { $0.flatMap { $0.snapshot } }, "condition": condition, "price": price, "photo": photo])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var attributes: [Attribute?] {
          get {
            return (snapshot["attributes"] as! [Snapshot?]).map { $0.flatMap { Attribute(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "attributes")
          }
        }

        public var condition: String {
          get {
            return snapshot["condition"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "condition")
          }
        }

        public var price: Double {
          get {
            return snapshot["price"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        public var photo: String {
          get {
            return snapshot["photo"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "photo")
          }
        }

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes = ["ItemAttribute"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("value", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, value: String) {
            self.init(snapshot: ["__typename": "ItemAttribute", "key": key, "value": value])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var value: String {
            get {
              return snapshot["value"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "value")
            }
          }
        }
      }

      public struct Story: GraphQLSelectionSet {
        public static let possibleTypes = ["Story"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("body", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(title: String, body: String) {
          self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var body: String {
          get {
            return snapshot["body"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }
      }

      public struct Topic: GraphQLSelectionSet {
        public static let possibleTypes = ["Topic"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
          self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var commentCount: Int {
          get {
            return snapshot["commentCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "commentCount")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var replyCount: Int {
          get {
            return snapshot["replyCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "replyCount")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var voteCount: Int {
          get {
            return snapshot["voteCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "voteCount")
          }
        }
      }

      public struct Theme: GraphQLSelectionSet {
        public static let possibleTypes = ["Theme"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundImage", type: .scalar(String.self)),
          GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
          self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var accentColor: String {
          get {
            return snapshot["accentColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "accentColor")
          }
        }

        public var backgroundColor: String {
          get {
            return snapshot["backgroundColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundColor")
          }
        }

        public var backgroundImage: String? {
          get {
            return snapshot["backgroundImage"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundImage")
          }
        }

        public var foreground: ThemeForeground {
          get {
            return snapshot["foreground"]! as! ThemeForeground
          }
          set {
            snapshot.updateValue(newValue, forKey: "foreground")
          }
        }
      }

      public struct PurchaseQuantity: GraphQLSelectionSet {
        public static let possibleTypes = ["PurchaseQuantity"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
          GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(maximumLimit: Int, minimumLimit: Int) {
          self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var maximumLimit: Int {
          get {
            return snapshot["maximumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "maximumLimit")
          }
        }

        public var minimumLimit: Int {
          get {
            return snapshot["minimumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "minimumLimit")
          }
        }
      }

      public struct Launch: GraphQLSelectionSet {
        public static let possibleTypes = ["Launch"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(soldOutAt: String? = nil) {
          self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }
      }
    }
  }
}

public final class UpdateDealMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateDeal($input: UpdateDealInput!, $condition: ModelDealConditionInput) {\n  updateDeal(input: $input, condition: $condition) {\n    __typename\n    id\n    dealID\n    dealYear\n    monthDay\n    title\n    features\n    specifications\n    url\n    createdAt\n    endDate\n    soldOutAt\n    items {\n      __typename\n      id\n      attributes {\n        __typename\n        key\n        value\n      }\n      condition\n      price\n      photo\n    }\n    modelNumbers\n    photos\n    story {\n      __typename\n      title\n      body\n    }\n    topic {\n      __typename\n      id\n      commentCount\n      createdAt\n      replyCount\n      url\n      voteCount\n    }\n    theme {\n      __typename\n      accentColor\n      backgroundColor\n      backgroundImage\n      foreground\n    }\n    purchaseQuantity {\n      __typename\n      maximumLimit\n      minimumLimit\n    }\n    launches {\n      __typename\n      soldOutAt\n    }\n    launchStatus\n    _version\n    _deleted\n    _lastChangedAt\n    updatedAt\n  }\n}"

  public var input: UpdateDealInput
  public var condition: ModelDealConditionInput?

  public init(input: UpdateDealInput, condition: ModelDealConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateDeal", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateDeal: UpdateDeal? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateDeal": updateDeal.flatMap { $0.snapshot }])
    }

    public var updateDeal: UpdateDeal? {
      get {
        return (snapshot["updateDeal"] as? Snapshot).flatMap { UpdateDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateDeal")
      }
    }

    public struct UpdateDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["Deal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
        GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("features", type: .nonNull(.scalar(String.self))),
        GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("endDate", type: .scalar(String.self)),
        GraphQLField("soldOutAt", type: .scalar(String.self)),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("story", type: .object(Story.selections)),
        GraphQLField("topic", type: .object(Topic.selections)),
        GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
        GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
        GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
        GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
        self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var dealId: GraphQLID {
        get {
          return snapshot["dealID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealID")
        }
      }

      public var dealYear: String {
        get {
          return snapshot["dealYear"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealYear")
        }
      }

      public var monthDay: String {
        get {
          return snapshot["monthDay"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "monthDay")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var features: String {
        get {
          return snapshot["features"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "features")
        }
      }

      public var specifications: String {
        get {
          return snapshot["specifications"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "specifications")
        }
      }

      public var url: String {
        get {
          return snapshot["url"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var endDate: String? {
        get {
          return snapshot["endDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "endDate")
        }
      }

      public var soldOutAt: String? {
        get {
          return snapshot["soldOutAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "soldOutAt")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var modelNumbers: [String]? {
        get {
          return snapshot["modelNumbers"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "modelNumbers")
        }
      }

      public var photos: [String] {
        get {
          return snapshot["photos"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "photos")
        }
      }

      public var story: Story? {
        get {
          return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "story")
        }
      }

      public var topic: Topic? {
        get {
          return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "topic")
        }
      }

      public var theme: Theme {
        get {
          return Theme(snapshot: snapshot["theme"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "theme")
        }
      }

      public var purchaseQuantity: PurchaseQuantity? {
        get {
          return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
        }
      }

      public var launches: [Launch]? {
        get {
          return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
        }
      }

      public var launchStatus: LaunchStatus {
        get {
          return snapshot["launchStatus"]! as! LaunchStatus
        }
        set {
          snapshot.updateValue(newValue, forKey: "launchStatus")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Item"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("attributes", type: .nonNull(.list(.object(Attribute.selections)))),
          GraphQLField("condition", type: .nonNull(.scalar(String.self))),
          GraphQLField("price", type: .nonNull(.scalar(Double.self))),
          GraphQLField("photo", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, attributes: [Attribute?], condition: String, price: Double, photo: String) {
          self.init(snapshot: ["__typename": "Item", "id": id, "attributes": attributes.map { $0.flatMap { $0.snapshot } }, "condition": condition, "price": price, "photo": photo])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var attributes: [Attribute?] {
          get {
            return (snapshot["attributes"] as! [Snapshot?]).map { $0.flatMap { Attribute(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "attributes")
          }
        }

        public var condition: String {
          get {
            return snapshot["condition"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "condition")
          }
        }

        public var price: Double {
          get {
            return snapshot["price"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        public var photo: String {
          get {
            return snapshot["photo"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "photo")
          }
        }

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes = ["ItemAttribute"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("value", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, value: String) {
            self.init(snapshot: ["__typename": "ItemAttribute", "key": key, "value": value])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var value: String {
            get {
              return snapshot["value"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "value")
            }
          }
        }
      }

      public struct Story: GraphQLSelectionSet {
        public static let possibleTypes = ["Story"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("body", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(title: String, body: String) {
          self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var body: String {
          get {
            return snapshot["body"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }
      }

      public struct Topic: GraphQLSelectionSet {
        public static let possibleTypes = ["Topic"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
          self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var commentCount: Int {
          get {
            return snapshot["commentCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "commentCount")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var replyCount: Int {
          get {
            return snapshot["replyCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "replyCount")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var voteCount: Int {
          get {
            return snapshot["voteCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "voteCount")
          }
        }
      }

      public struct Theme: GraphQLSelectionSet {
        public static let possibleTypes = ["Theme"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundImage", type: .scalar(String.self)),
          GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
          self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var accentColor: String {
          get {
            return snapshot["accentColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "accentColor")
          }
        }

        public var backgroundColor: String {
          get {
            return snapshot["backgroundColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundColor")
          }
        }

        public var backgroundImage: String? {
          get {
            return snapshot["backgroundImage"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundImage")
          }
        }

        public var foreground: ThemeForeground {
          get {
            return snapshot["foreground"]! as! ThemeForeground
          }
          set {
            snapshot.updateValue(newValue, forKey: "foreground")
          }
        }
      }

      public struct PurchaseQuantity: GraphQLSelectionSet {
        public static let possibleTypes = ["PurchaseQuantity"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
          GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(maximumLimit: Int, minimumLimit: Int) {
          self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var maximumLimit: Int {
          get {
            return snapshot["maximumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "maximumLimit")
          }
        }

        public var minimumLimit: Int {
          get {
            return snapshot["minimumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "minimumLimit")
          }
        }
      }

      public struct Launch: GraphQLSelectionSet {
        public static let possibleTypes = ["Launch"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(soldOutAt: String? = nil) {
          self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }
      }
    }
  }
}

public final class DeleteDealMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteDeal($input: DeleteDealInput!, $condition: ModelDealConditionInput) {\n  deleteDeal(input: $input, condition: $condition) {\n    __typename\n    id\n    dealID\n    dealYear\n    monthDay\n    title\n    features\n    specifications\n    url\n    createdAt\n    endDate\n    soldOutAt\n    items {\n      __typename\n      id\n      attributes {\n        __typename\n        key\n        value\n      }\n      condition\n      price\n      photo\n    }\n    modelNumbers\n    photos\n    story {\n      __typename\n      title\n      body\n    }\n    topic {\n      __typename\n      id\n      commentCount\n      createdAt\n      replyCount\n      url\n      voteCount\n    }\n    theme {\n      __typename\n      accentColor\n      backgroundColor\n      backgroundImage\n      foreground\n    }\n    purchaseQuantity {\n      __typename\n      maximumLimit\n      minimumLimit\n    }\n    launches {\n      __typename\n      soldOutAt\n    }\n    launchStatus\n    _version\n    _deleted\n    _lastChangedAt\n    updatedAt\n  }\n}"

  public var input: DeleteDealInput
  public var condition: ModelDealConditionInput?

  public init(input: DeleteDealInput, condition: ModelDealConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteDeal", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteDeal: DeleteDeal? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteDeal": deleteDeal.flatMap { $0.snapshot }])
    }

    public var deleteDeal: DeleteDeal? {
      get {
        return (snapshot["deleteDeal"] as? Snapshot).flatMap { DeleteDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteDeal")
      }
    }

    public struct DeleteDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["Deal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
        GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("features", type: .nonNull(.scalar(String.self))),
        GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("endDate", type: .scalar(String.self)),
        GraphQLField("soldOutAt", type: .scalar(String.self)),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("story", type: .object(Story.selections)),
        GraphQLField("topic", type: .object(Topic.selections)),
        GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
        GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
        GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
        GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
        self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var dealId: GraphQLID {
        get {
          return snapshot["dealID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealID")
        }
      }

      public var dealYear: String {
        get {
          return snapshot["dealYear"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealYear")
        }
      }

      public var monthDay: String {
        get {
          return snapshot["monthDay"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "monthDay")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var features: String {
        get {
          return snapshot["features"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "features")
        }
      }

      public var specifications: String {
        get {
          return snapshot["specifications"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "specifications")
        }
      }

      public var url: String {
        get {
          return snapshot["url"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var endDate: String? {
        get {
          return snapshot["endDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "endDate")
        }
      }

      public var soldOutAt: String? {
        get {
          return snapshot["soldOutAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "soldOutAt")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var modelNumbers: [String]? {
        get {
          return snapshot["modelNumbers"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "modelNumbers")
        }
      }

      public var photos: [String] {
        get {
          return snapshot["photos"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "photos")
        }
      }

      public var story: Story? {
        get {
          return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "story")
        }
      }

      public var topic: Topic? {
        get {
          return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "topic")
        }
      }

      public var theme: Theme {
        get {
          return Theme(snapshot: snapshot["theme"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "theme")
        }
      }

      public var purchaseQuantity: PurchaseQuantity? {
        get {
          return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
        }
      }

      public var launches: [Launch]? {
        get {
          return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
        }
      }

      public var launchStatus: LaunchStatus {
        get {
          return snapshot["launchStatus"]! as! LaunchStatus
        }
        set {
          snapshot.updateValue(newValue, forKey: "launchStatus")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Item"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("attributes", type: .nonNull(.list(.object(Attribute.selections)))),
          GraphQLField("condition", type: .nonNull(.scalar(String.self))),
          GraphQLField("price", type: .nonNull(.scalar(Double.self))),
          GraphQLField("photo", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, attributes: [Attribute?], condition: String, price: Double, photo: String) {
          self.init(snapshot: ["__typename": "Item", "id": id, "attributes": attributes.map { $0.flatMap { $0.snapshot } }, "condition": condition, "price": price, "photo": photo])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var attributes: [Attribute?] {
          get {
            return (snapshot["attributes"] as! [Snapshot?]).map { $0.flatMap { Attribute(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "attributes")
          }
        }

        public var condition: String {
          get {
            return snapshot["condition"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "condition")
          }
        }

        public var price: Double {
          get {
            return snapshot["price"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        public var photo: String {
          get {
            return snapshot["photo"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "photo")
          }
        }

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes = ["ItemAttribute"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("value", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, value: String) {
            self.init(snapshot: ["__typename": "ItemAttribute", "key": key, "value": value])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var value: String {
            get {
              return snapshot["value"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "value")
            }
          }
        }
      }

      public struct Story: GraphQLSelectionSet {
        public static let possibleTypes = ["Story"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("body", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(title: String, body: String) {
          self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var body: String {
          get {
            return snapshot["body"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }
      }

      public struct Topic: GraphQLSelectionSet {
        public static let possibleTypes = ["Topic"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
          self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var commentCount: Int {
          get {
            return snapshot["commentCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "commentCount")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var replyCount: Int {
          get {
            return snapshot["replyCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "replyCount")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var voteCount: Int {
          get {
            return snapshot["voteCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "voteCount")
          }
        }
      }

      public struct Theme: GraphQLSelectionSet {
        public static let possibleTypes = ["Theme"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundImage", type: .scalar(String.self)),
          GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
          self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var accentColor: String {
          get {
            return snapshot["accentColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "accentColor")
          }
        }

        public var backgroundColor: String {
          get {
            return snapshot["backgroundColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundColor")
          }
        }

        public var backgroundImage: String? {
          get {
            return snapshot["backgroundImage"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundImage")
          }
        }

        public var foreground: ThemeForeground {
          get {
            return snapshot["foreground"]! as! ThemeForeground
          }
          set {
            snapshot.updateValue(newValue, forKey: "foreground")
          }
        }
      }

      public struct PurchaseQuantity: GraphQLSelectionSet {
        public static let possibleTypes = ["PurchaseQuantity"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
          GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(maximumLimit: Int, minimumLimit: Int) {
          self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var maximumLimit: Int {
          get {
            return snapshot["maximumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "maximumLimit")
          }
        }

        public var minimumLimit: Int {
          get {
            return snapshot["minimumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "minimumLimit")
          }
        }
      }

      public struct Launch: GraphQLSelectionSet {
        public static let possibleTypes = ["Launch"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(soldOutAt: String? = nil) {
          self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }
      }
    }
  }
}

public final class DealHistoryQuery: GraphQLQuery {
  public static let operationString =
    "query DealHistory($filter: DealHistoryFilterInput, $limit: Int, $nextToken: String) {\n  dealHistory(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      title\n      createdAt\n      dealYear\n      monthDay\n      items {\n        __typename\n        id\n        condition\n        price\n        photo\n      }\n      photos\n      theme {\n        __typename\n        accentColor\n        backgroundColor\n        backgroundImage\n        foreground\n      }\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: DealHistoryFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: DealHistoryFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("dealHistory", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(DealHistory.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(dealHistory: DealHistory? = nil) {
      self.init(snapshot: ["__typename": "Query", "dealHistory": dealHistory.flatMap { $0.snapshot }])
    }

    public var dealHistory: DealHistory? {
      get {
        return (snapshot["dealHistory"] as? Snapshot).flatMap { DealHistory(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "dealHistory")
      }
    }

    public struct DealHistory: GraphQLSelectionSet {
      public static let possibleTypes = ["DealHistoryConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.object(Item.selections))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?]? = nil, nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "DealHistoryConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?]? {
        get {
          return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["DealHistoryResult"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
          GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
          GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
          GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, title: String, createdAt: String, dealYear: String, monthDay: String, items: [Item], photos: [String], theme: Theme) {
          self.init(snapshot: ["__typename": "DealHistoryResult", "id": id, "title": title, "createdAt": createdAt, "dealYear": dealYear, "monthDay": monthDay, "items": items.map { $0.snapshot }, "photos": photos, "theme": theme.snapshot])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var dealYear: String {
          get {
            return snapshot["dealYear"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "dealYear")
          }
        }

        public var monthDay: String {
          get {
            return snapshot["monthDay"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "monthDay")
          }
        }

        public var items: [Item] {
          get {
            return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
          }
        }

        public var photos: [String] {
          get {
            return snapshot["photos"]! as! [String]
          }
          set {
            snapshot.updateValue(newValue, forKey: "photos")
          }
        }

        public var theme: Theme {
          get {
            return Theme(snapshot: snapshot["theme"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "theme")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Item"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("condition", type: .nonNull(.scalar(String.self))),
            GraphQLField("price", type: .nonNull(.scalar(Double.self))),
            GraphQLField("photo", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, condition: String, price: Double, photo: String) {
            self.init(snapshot: ["__typename": "Item", "id": id, "condition": condition, "price": price, "photo": photo])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var condition: String {
            get {
              return snapshot["condition"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "condition")
            }
          }

          public var price: Double {
            get {
              return snapshot["price"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var photo: String {
            get {
              return snapshot["photo"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "photo")
            }
          }
        }

        public struct Theme: GraphQLSelectionSet {
          public static let possibleTypes = ["Theme"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
            GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
            GraphQLField("backgroundImage", type: .scalar(String.self)),
            GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
            self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var accentColor: String {
            get {
              return snapshot["accentColor"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "accentColor")
            }
          }

          public var backgroundColor: String {
            get {
              return snapshot["backgroundColor"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "backgroundColor")
            }
          }

          public var backgroundImage: String? {
            get {
              return snapshot["backgroundImage"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "backgroundImage")
            }
          }

          public var foreground: ThemeForeground {
            get {
              return snapshot["foreground"]! as! ThemeForeground
            }
            set {
              snapshot.updateValue(newValue, forKey: "foreground")
            }
          }
        }
      }
    }
  }
}

public final class SyncDealsQuery: GraphQLQuery {
  public static let operationString =
    "query SyncDeals($filter: ModelDealFilterInput, $limit: Int, $nextToken: String, $lastSync: AWSTimestamp) {\n  syncDeals(filter: $filter, limit: $limit, nextToken: $nextToken, lastSync: $lastSync) {\n    __typename\n    items {\n      __typename\n      id\n      dealID\n      dealYear\n      monthDay\n      title\n      features\n      specifications\n      url\n      createdAt\n      endDate\n      soldOutAt\n      items {\n        __typename\n        id\n        condition\n        price\n        photo\n      }\n      modelNumbers\n      photos\n      story {\n        __typename\n        title\n        body\n      }\n      topic {\n        __typename\n        id\n        commentCount\n        createdAt\n        replyCount\n        url\n        voteCount\n      }\n      theme {\n        __typename\n        accentColor\n        backgroundColor\n        backgroundImage\n        foreground\n      }\n      purchaseQuantity {\n        __typename\n        maximumLimit\n        minimumLimit\n      }\n      launches {\n        __typename\n        soldOutAt\n      }\n      launchStatus\n      _version\n      _deleted\n      _lastChangedAt\n      updatedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelDealFilterInput?
  public var limit: Int?
  public var nextToken: String?
  public var lastSync: Int?

  public init(filter: ModelDealFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil, lastSync: Int? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
    self.lastSync = lastSync
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken, "lastSync": lastSync]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("syncDeals", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken"), "lastSync": GraphQLVariable("lastSync")], type: .object(SyncDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(syncDeals: SyncDeal? = nil) {
      self.init(snapshot: ["__typename": "Query", "syncDeals": syncDeals.flatMap { $0.snapshot }])
    }

    public var syncDeals: SyncDeal? {
      get {
        return (snapshot["syncDeals"] as? Snapshot).flatMap { SyncDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "syncDeals")
      }
    }

    public struct SyncDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelDealConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.object(Item.selections))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?]? = nil, nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelDealConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?]? {
        get {
          return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Deal"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
          GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("features", type: .nonNull(.scalar(String.self))),
          GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("endDate", type: .scalar(String.self)),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
          GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
          GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
          GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("story", type: .object(Story.selections)),
          GraphQLField("topic", type: .object(Topic.selections)),
          GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
          GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
          GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
          GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
          self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var dealId: GraphQLID {
          get {
            return snapshot["dealID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "dealID")
          }
        }

        public var dealYear: String {
          get {
            return snapshot["dealYear"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "dealYear")
          }
        }

        public var monthDay: String {
          get {
            return snapshot["monthDay"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "monthDay")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var features: String {
          get {
            return snapshot["features"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "features")
          }
        }

        public var specifications: String {
          get {
            return snapshot["specifications"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "specifications")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var endDate: String? {
          get {
            return snapshot["endDate"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "endDate")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }

        public var items: [Item] {
          get {
            return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
          }
        }

        public var modelNumbers: [String]? {
          get {
            return snapshot["modelNumbers"] as? [String]
          }
          set {
            snapshot.updateValue(newValue, forKey: "modelNumbers")
          }
        }

        public var photos: [String] {
          get {
            return snapshot["photos"]! as! [String]
          }
          set {
            snapshot.updateValue(newValue, forKey: "photos")
          }
        }

        public var story: Story? {
          get {
            return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "story")
          }
        }

        public var topic: Topic? {
          get {
            return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "topic")
          }
        }

        public var theme: Theme {
          get {
            return Theme(snapshot: snapshot["theme"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "theme")
          }
        }

        public var purchaseQuantity: PurchaseQuantity? {
          get {
            return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
          }
        }

        public var launches: [Launch]? {
          get {
            return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
          }
        }

        public var launchStatus: LaunchStatus {
          get {
            return snapshot["launchStatus"]! as! LaunchStatus
          }
          set {
            snapshot.updateValue(newValue, forKey: "launchStatus")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Item"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("condition", type: .nonNull(.scalar(String.self))),
            GraphQLField("price", type: .nonNull(.scalar(Double.self))),
            GraphQLField("photo", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, condition: String, price: Double, photo: String) {
            self.init(snapshot: ["__typename": "Item", "id": id, "condition": condition, "price": price, "photo": photo])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var condition: String {
            get {
              return snapshot["condition"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "condition")
            }
          }

          public var price: Double {
            get {
              return snapshot["price"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var photo: String {
            get {
              return snapshot["photo"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "photo")
            }
          }
        }

        public struct Story: GraphQLSelectionSet {
          public static let possibleTypes = ["Story"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("body", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(title: String, body: String) {
            self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var title: String {
            get {
              return snapshot["title"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "title")
            }
          }

          public var body: String {
            get {
              return snapshot["body"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "body")
            }
          }
        }

        public struct Topic: GraphQLSelectionSet {
          public static let possibleTypes = ["Topic"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("url", type: .nonNull(.scalar(String.self))),
            GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
            self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var commentCount: Int {
            get {
              return snapshot["commentCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "commentCount")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var replyCount: Int {
            get {
              return snapshot["replyCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "replyCount")
            }
          }

          public var url: String {
            get {
              return snapshot["url"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "url")
            }
          }

          public var voteCount: Int {
            get {
              return snapshot["voteCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "voteCount")
            }
          }
        }

        public struct Theme: GraphQLSelectionSet {
          public static let possibleTypes = ["Theme"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
            GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
            GraphQLField("backgroundImage", type: .scalar(String.self)),
            GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
            self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var accentColor: String {
            get {
              return snapshot["accentColor"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "accentColor")
            }
          }

          public var backgroundColor: String {
            get {
              return snapshot["backgroundColor"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "backgroundColor")
            }
          }

          public var backgroundImage: String? {
            get {
              return snapshot["backgroundImage"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "backgroundImage")
            }
          }

          public var foreground: ThemeForeground {
            get {
              return snapshot["foreground"]! as! ThemeForeground
            }
            set {
              snapshot.updateValue(newValue, forKey: "foreground")
            }
          }
        }

        public struct PurchaseQuantity: GraphQLSelectionSet {
          public static let possibleTypes = ["PurchaseQuantity"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
            GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(maximumLimit: Int, minimumLimit: Int) {
            self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var maximumLimit: Int {
            get {
              return snapshot["maximumLimit"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "maximumLimit")
            }
          }

          public var minimumLimit: Int {
            get {
              return snapshot["minimumLimit"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "minimumLimit")
            }
          }
        }

        public struct Launch: GraphQLSelectionSet {
          public static let possibleTypes = ["Launch"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("soldOutAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(soldOutAt: String? = nil) {
            self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var soldOutAt: String? {
            get {
              return snapshot["soldOutAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "soldOutAt")
            }
          }
        }
      }
    }
  }
}

public final class GetDealQuery: GraphQLQuery {
  public static let operationString =
    "query GetDeal($id: ID!) {\n  getDeal(id: $id) {\n    __typename\n    id\n    dealID\n    dealYear\n    monthDay\n    title\n    features\n    specifications\n    url\n    createdAt\n    endDate\n    soldOutAt\n    items {\n      __typename\n      id\n      attributes {\n        __typename\n        key\n        value\n      }\n      condition\n      price\n      photo\n    }\n    modelNumbers\n    photos\n    story {\n      __typename\n      title\n      body\n    }\n    topic {\n      __typename\n      id\n      commentCount\n      createdAt\n      replyCount\n      url\n      voteCount\n    }\n    theme {\n      __typename\n      accentColor\n      backgroundColor\n      backgroundImage\n      foreground\n    }\n    purchaseQuantity {\n      __typename\n      maximumLimit\n      minimumLimit\n    }\n    launches {\n      __typename\n      soldOutAt\n    }\n    launchStatus\n    _version\n    _deleted\n    _lastChangedAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getDeal", arguments: ["id": GraphQLVariable("id")], type: .object(GetDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getDeal: GetDeal? = nil) {
      self.init(snapshot: ["__typename": "Query", "getDeal": getDeal.flatMap { $0.snapshot }])
    }

    public var getDeal: GetDeal? {
      get {
        return (snapshot["getDeal"] as? Snapshot).flatMap { GetDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getDeal")
      }
    }

    public struct GetDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["Deal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
        GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("features", type: .nonNull(.scalar(String.self))),
        GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("endDate", type: .scalar(String.self)),
        GraphQLField("soldOutAt", type: .scalar(String.self)),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("story", type: .object(Story.selections)),
        GraphQLField("topic", type: .object(Topic.selections)),
        GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
        GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
        GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
        GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
        self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var dealId: GraphQLID {
        get {
          return snapshot["dealID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealID")
        }
      }

      public var dealYear: String {
        get {
          return snapshot["dealYear"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealYear")
        }
      }

      public var monthDay: String {
        get {
          return snapshot["monthDay"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "monthDay")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var features: String {
        get {
          return snapshot["features"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "features")
        }
      }

      public var specifications: String {
        get {
          return snapshot["specifications"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "specifications")
        }
      }

      public var url: String {
        get {
          return snapshot["url"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var endDate: String? {
        get {
          return snapshot["endDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "endDate")
        }
      }

      public var soldOutAt: String? {
        get {
          return snapshot["soldOutAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "soldOutAt")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var modelNumbers: [String]? {
        get {
          return snapshot["modelNumbers"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "modelNumbers")
        }
      }

      public var photos: [String] {
        get {
          return snapshot["photos"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "photos")
        }
      }

      public var story: Story? {
        get {
          return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "story")
        }
      }

      public var topic: Topic? {
        get {
          return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "topic")
        }
      }

      public var theme: Theme {
        get {
          return Theme(snapshot: snapshot["theme"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "theme")
        }
      }

      public var purchaseQuantity: PurchaseQuantity? {
        get {
          return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
        }
      }

      public var launches: [Launch]? {
        get {
          return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
        }
      }

      public var launchStatus: LaunchStatus {
        get {
          return snapshot["launchStatus"]! as! LaunchStatus
        }
        set {
          snapshot.updateValue(newValue, forKey: "launchStatus")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Item"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("attributes", type: .nonNull(.list(.object(Attribute.selections)))),
          GraphQLField("condition", type: .nonNull(.scalar(String.self))),
          GraphQLField("price", type: .nonNull(.scalar(Double.self))),
          GraphQLField("photo", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, attributes: [Attribute?], condition: String, price: Double, photo: String) {
          self.init(snapshot: ["__typename": "Item", "id": id, "attributes": attributes.map { $0.flatMap { $0.snapshot } }, "condition": condition, "price": price, "photo": photo])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var attributes: [Attribute?] {
          get {
            return (snapshot["attributes"] as! [Snapshot?]).map { $0.flatMap { Attribute(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "attributes")
          }
        }

        public var condition: String {
          get {
            return snapshot["condition"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "condition")
          }
        }

        public var price: Double {
          get {
            return snapshot["price"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        public var photo: String {
          get {
            return snapshot["photo"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "photo")
          }
        }

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes = ["ItemAttribute"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("value", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, value: String) {
            self.init(snapshot: ["__typename": "ItemAttribute", "key": key, "value": value])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var value: String {
            get {
              return snapshot["value"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "value")
            }
          }
        }
      }

      public struct Story: GraphQLSelectionSet {
        public static let possibleTypes = ["Story"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("body", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(title: String, body: String) {
          self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var body: String {
          get {
            return snapshot["body"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }
      }

      public struct Topic: GraphQLSelectionSet {
        public static let possibleTypes = ["Topic"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
          self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var commentCount: Int {
          get {
            return snapshot["commentCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "commentCount")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var replyCount: Int {
          get {
            return snapshot["replyCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "replyCount")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var voteCount: Int {
          get {
            return snapshot["voteCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "voteCount")
          }
        }
      }

      public struct Theme: GraphQLSelectionSet {
        public static let possibleTypes = ["Theme"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundImage", type: .scalar(String.self)),
          GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
          self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var accentColor: String {
          get {
            return snapshot["accentColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "accentColor")
          }
        }

        public var backgroundColor: String {
          get {
            return snapshot["backgroundColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundColor")
          }
        }

        public var backgroundImage: String? {
          get {
            return snapshot["backgroundImage"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundImage")
          }
        }

        public var foreground: ThemeForeground {
          get {
            return snapshot["foreground"]! as! ThemeForeground
          }
          set {
            snapshot.updateValue(newValue, forKey: "foreground")
          }
        }
      }

      public struct PurchaseQuantity: GraphQLSelectionSet {
        public static let possibleTypes = ["PurchaseQuantity"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
          GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(maximumLimit: Int, minimumLimit: Int) {
          self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var maximumLimit: Int {
          get {
            return snapshot["maximumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "maximumLimit")
          }
        }

        public var minimumLimit: Int {
          get {
            return snapshot["minimumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "minimumLimit")
          }
        }
      }

      public struct Launch: GraphQLSelectionSet {
        public static let possibleTypes = ["Launch"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(soldOutAt: String? = nil) {
          self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }
      }
    }
  }
}

public final class ListDealsQuery: GraphQLQuery {
  public static let operationString =
    "query ListDeals($filter: ModelDealFilterInput, $limit: Int, $nextToken: String) {\n  listDeals(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      dealID\n      dealYear\n      monthDay\n      title\n      features\n      specifications\n      url\n      createdAt\n      endDate\n      soldOutAt\n      items {\n        __typename\n        id\n        condition\n        price\n        photo\n      }\n      modelNumbers\n      photos\n      story {\n        __typename\n        title\n        body\n      }\n      topic {\n        __typename\n        id\n        commentCount\n        createdAt\n        replyCount\n        url\n        voteCount\n      }\n      theme {\n        __typename\n        accentColor\n        backgroundColor\n        backgroundImage\n        foreground\n      }\n      purchaseQuantity {\n        __typename\n        maximumLimit\n        minimumLimit\n      }\n      launches {\n        __typename\n        soldOutAt\n      }\n      launchStatus\n      _version\n      _deleted\n      _lastChangedAt\n      updatedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var filter: ModelDealFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelDealFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listDeals", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listDeals: ListDeal? = nil) {
      self.init(snapshot: ["__typename": "Query", "listDeals": listDeals.flatMap { $0.snapshot }])
    }

    public var listDeals: ListDeal? {
      get {
        return (snapshot["listDeals"] as? Snapshot).flatMap { ListDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listDeals")
      }
    }

    public struct ListDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelDealConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.object(Item.selections))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?]? = nil, nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelDealConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?]? {
        get {
          return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Deal"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
          GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("features", type: .nonNull(.scalar(String.self))),
          GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("endDate", type: .scalar(String.self)),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
          GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
          GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
          GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("story", type: .object(Story.selections)),
          GraphQLField("topic", type: .object(Topic.selections)),
          GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
          GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
          GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
          GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
          self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var dealId: GraphQLID {
          get {
            return snapshot["dealID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "dealID")
          }
        }

        public var dealYear: String {
          get {
            return snapshot["dealYear"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "dealYear")
          }
        }

        public var monthDay: String {
          get {
            return snapshot["monthDay"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "monthDay")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var features: String {
          get {
            return snapshot["features"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "features")
          }
        }

        public var specifications: String {
          get {
            return snapshot["specifications"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "specifications")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var endDate: String? {
          get {
            return snapshot["endDate"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "endDate")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }

        public var items: [Item] {
          get {
            return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
          }
        }

        public var modelNumbers: [String]? {
          get {
            return snapshot["modelNumbers"] as? [String]
          }
          set {
            snapshot.updateValue(newValue, forKey: "modelNumbers")
          }
        }

        public var photos: [String] {
          get {
            return snapshot["photos"]! as! [String]
          }
          set {
            snapshot.updateValue(newValue, forKey: "photos")
          }
        }

        public var story: Story? {
          get {
            return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "story")
          }
        }

        public var topic: Topic? {
          get {
            return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "topic")
          }
        }

        public var theme: Theme {
          get {
            return Theme(snapshot: snapshot["theme"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "theme")
          }
        }

        public var purchaseQuantity: PurchaseQuantity? {
          get {
            return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
          }
        }

        public var launches: [Launch]? {
          get {
            return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
          }
        }

        public var launchStatus: LaunchStatus {
          get {
            return snapshot["launchStatus"]! as! LaunchStatus
          }
          set {
            snapshot.updateValue(newValue, forKey: "launchStatus")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Item"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("condition", type: .nonNull(.scalar(String.self))),
            GraphQLField("price", type: .nonNull(.scalar(Double.self))),
            GraphQLField("photo", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, condition: String, price: Double, photo: String) {
            self.init(snapshot: ["__typename": "Item", "id": id, "condition": condition, "price": price, "photo": photo])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var condition: String {
            get {
              return snapshot["condition"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "condition")
            }
          }

          public var price: Double {
            get {
              return snapshot["price"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var photo: String {
            get {
              return snapshot["photo"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "photo")
            }
          }
        }

        public struct Story: GraphQLSelectionSet {
          public static let possibleTypes = ["Story"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("body", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(title: String, body: String) {
            self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var title: String {
            get {
              return snapshot["title"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "title")
            }
          }

          public var body: String {
            get {
              return snapshot["body"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "body")
            }
          }
        }

        public struct Topic: GraphQLSelectionSet {
          public static let possibleTypes = ["Topic"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("url", type: .nonNull(.scalar(String.self))),
            GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
            self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var commentCount: Int {
            get {
              return snapshot["commentCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "commentCount")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var replyCount: Int {
            get {
              return snapshot["replyCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "replyCount")
            }
          }

          public var url: String {
            get {
              return snapshot["url"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "url")
            }
          }

          public var voteCount: Int {
            get {
              return snapshot["voteCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "voteCount")
            }
          }
        }

        public struct Theme: GraphQLSelectionSet {
          public static let possibleTypes = ["Theme"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
            GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
            GraphQLField("backgroundImage", type: .scalar(String.self)),
            GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
            self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var accentColor: String {
            get {
              return snapshot["accentColor"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "accentColor")
            }
          }

          public var backgroundColor: String {
            get {
              return snapshot["backgroundColor"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "backgroundColor")
            }
          }

          public var backgroundImage: String? {
            get {
              return snapshot["backgroundImage"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "backgroundImage")
            }
          }

          public var foreground: ThemeForeground {
            get {
              return snapshot["foreground"]! as! ThemeForeground
            }
            set {
              snapshot.updateValue(newValue, forKey: "foreground")
            }
          }
        }

        public struct PurchaseQuantity: GraphQLSelectionSet {
          public static let possibleTypes = ["PurchaseQuantity"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
            GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(maximumLimit: Int, minimumLimit: Int) {
            self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var maximumLimit: Int {
            get {
              return snapshot["maximumLimit"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "maximumLimit")
            }
          }

          public var minimumLimit: Int {
            get {
              return snapshot["minimumLimit"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "minimumLimit")
            }
          }
        }

        public struct Launch: GraphQLSelectionSet {
          public static let possibleTypes = ["Launch"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("soldOutAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(soldOutAt: String? = nil) {
            self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var soldOutAt: String? {
            get {
              return snapshot["soldOutAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "soldOutAt")
            }
          }
        }
      }
    }
  }
}

public final class DealsForPeriodQuery: GraphQLQuery {
  public static let operationString =
    "query DealsForPeriod($dealYear: String, $monthDay: ModelStringKeyConditionInput, $sortDirection: ModelSortDirection, $filter: ModelDealFilterInput, $limit: Int, $nextToken: String) {\n  dealsForPeriod(dealYear: $dealYear, monthDay: $monthDay, sortDirection: $sortDirection, filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      dealID\n      dealYear\n      monthDay\n      title\n      features\n      specifications\n      url\n      createdAt\n      endDate\n      soldOutAt\n      items {\n        __typename\n        id\n        condition\n        price\n        photo\n      }\n      modelNumbers\n      photos\n      story {\n        __typename\n        title\n        body\n      }\n      topic {\n        __typename\n        id\n        commentCount\n        createdAt\n        replyCount\n        url\n        voteCount\n      }\n      theme {\n        __typename\n        accentColor\n        backgroundColor\n        backgroundImage\n        foreground\n      }\n      purchaseQuantity {\n        __typename\n        maximumLimit\n        minimumLimit\n      }\n      launches {\n        __typename\n        soldOutAt\n      }\n      launchStatus\n      _version\n      _deleted\n      _lastChangedAt\n      updatedAt\n    }\n    nextToken\n    startedAt\n  }\n}"

  public var dealYear: String?
  public var monthDay: ModelStringKeyConditionInput?
  public var sortDirection: ModelSortDirection?
  public var filter: ModelDealFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(dealYear: String? = nil, monthDay: ModelStringKeyConditionInput? = nil, sortDirection: ModelSortDirection? = nil, filter: ModelDealFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.dealYear = dealYear
    self.monthDay = monthDay
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["dealYear": dealYear, "monthDay": monthDay, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("dealsForPeriod", arguments: ["dealYear": GraphQLVariable("dealYear"), "monthDay": GraphQLVariable("monthDay"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(DealsForPeriod.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(dealsForPeriod: DealsForPeriod? = nil) {
      self.init(snapshot: ["__typename": "Query", "dealsForPeriod": dealsForPeriod.flatMap { $0.snapshot }])
    }

    public var dealsForPeriod: DealsForPeriod? {
      get {
        return (snapshot["dealsForPeriod"] as? Snapshot).flatMap { DealsForPeriod(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "dealsForPeriod")
      }
    }

    public struct DealsForPeriod: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelDealConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .list(.object(Item.selections))),
        GraphQLField("nextToken", type: .scalar(String.self)),
        GraphQLField("startedAt", type: .scalar(Int.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?]? = nil, nextToken: String? = nil, startedAt: Int? = nil) {
        self.init(snapshot: ["__typename": "ModelDealConnection", "items": items.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, "nextToken": nextToken, "startedAt": startedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?]? {
        get {
          return (snapshot["items"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { Item(snapshot: $0) } } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public var startedAt: Int? {
        get {
          return snapshot["startedAt"] as? Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "startedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Deal"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
          GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("features", type: .nonNull(.scalar(String.self))),
          GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("endDate", type: .scalar(String.self)),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
          GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
          GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
          GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("story", type: .object(Story.selections)),
          GraphQLField("topic", type: .object(Topic.selections)),
          GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
          GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
          GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
          GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
          GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
          GraphQLField("_deleted", type: .scalar(Bool.self)),
          GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
          self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var dealId: GraphQLID {
          get {
            return snapshot["dealID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "dealID")
          }
        }

        public var dealYear: String {
          get {
            return snapshot["dealYear"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "dealYear")
          }
        }

        public var monthDay: String {
          get {
            return snapshot["monthDay"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "monthDay")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var features: String {
          get {
            return snapshot["features"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "features")
          }
        }

        public var specifications: String {
          get {
            return snapshot["specifications"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "specifications")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var endDate: String? {
          get {
            return snapshot["endDate"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "endDate")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }

        public var items: [Item] {
          get {
            return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
          }
        }

        public var modelNumbers: [String]? {
          get {
            return snapshot["modelNumbers"] as? [String]
          }
          set {
            snapshot.updateValue(newValue, forKey: "modelNumbers")
          }
        }

        public var photos: [String] {
          get {
            return snapshot["photos"]! as! [String]
          }
          set {
            snapshot.updateValue(newValue, forKey: "photos")
          }
        }

        public var story: Story? {
          get {
            return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "story")
          }
        }

        public var topic: Topic? {
          get {
            return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "topic")
          }
        }

        public var theme: Theme {
          get {
            return Theme(snapshot: snapshot["theme"]! as! Snapshot)
          }
          set {
            snapshot.updateValue(newValue.snapshot, forKey: "theme")
          }
        }

        public var purchaseQuantity: PurchaseQuantity? {
          get {
            return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
          }
          set {
            snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
          }
        }

        public var launches: [Launch]? {
          get {
            return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
          }
        }

        public var launchStatus: LaunchStatus {
          get {
            return snapshot["launchStatus"]! as! LaunchStatus
          }
          set {
            snapshot.updateValue(newValue, forKey: "launchStatus")
          }
        }

        public var version: Int {
          get {
            return snapshot["_version"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_version")
          }
        }

        public var deleted: Bool? {
          get {
            return snapshot["_deleted"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "_deleted")
          }
        }

        public var lastChangedAt: Int {
          get {
            return snapshot["_lastChangedAt"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "_lastChangedAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public struct Item: GraphQLSelectionSet {
          public static let possibleTypes = ["Item"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("condition", type: .nonNull(.scalar(String.self))),
            GraphQLField("price", type: .nonNull(.scalar(Double.self))),
            GraphQLField("photo", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, condition: String, price: Double, photo: String) {
            self.init(snapshot: ["__typename": "Item", "id": id, "condition": condition, "price": price, "photo": photo])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var condition: String {
            get {
              return snapshot["condition"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "condition")
            }
          }

          public var price: Double {
            get {
              return snapshot["price"]! as! Double
            }
            set {
              snapshot.updateValue(newValue, forKey: "price")
            }
          }

          public var photo: String {
            get {
              return snapshot["photo"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "photo")
            }
          }
        }

        public struct Story: GraphQLSelectionSet {
          public static let possibleTypes = ["Story"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("body", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(title: String, body: String) {
            self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var title: String {
            get {
              return snapshot["title"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "title")
            }
          }

          public var body: String {
            get {
              return snapshot["body"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "body")
            }
          }
        }

        public struct Topic: GraphQLSelectionSet {
          public static let possibleTypes = ["Topic"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("url", type: .nonNull(.scalar(String.self))),
            GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
            self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return snapshot["id"]! as! GraphQLID
            }
            set {
              snapshot.updateValue(newValue, forKey: "id")
            }
          }

          public var commentCount: Int {
            get {
              return snapshot["commentCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "commentCount")
            }
          }

          public var createdAt: String {
            get {
              return snapshot["createdAt"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "createdAt")
            }
          }

          public var replyCount: Int {
            get {
              return snapshot["replyCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "replyCount")
            }
          }

          public var url: String {
            get {
              return snapshot["url"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "url")
            }
          }

          public var voteCount: Int {
            get {
              return snapshot["voteCount"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "voteCount")
            }
          }
        }

        public struct Theme: GraphQLSelectionSet {
          public static let possibleTypes = ["Theme"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
            GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
            GraphQLField("backgroundImage", type: .scalar(String.self)),
            GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
            self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var accentColor: String {
            get {
              return snapshot["accentColor"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "accentColor")
            }
          }

          public var backgroundColor: String {
            get {
              return snapshot["backgroundColor"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "backgroundColor")
            }
          }

          public var backgroundImage: String? {
            get {
              return snapshot["backgroundImage"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "backgroundImage")
            }
          }

          public var foreground: ThemeForeground {
            get {
              return snapshot["foreground"]! as! ThemeForeground
            }
            set {
              snapshot.updateValue(newValue, forKey: "foreground")
            }
          }
        }

        public struct PurchaseQuantity: GraphQLSelectionSet {
          public static let possibleTypes = ["PurchaseQuantity"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
            GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(maximumLimit: Int, minimumLimit: Int) {
            self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var maximumLimit: Int {
            get {
              return snapshot["maximumLimit"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "maximumLimit")
            }
          }

          public var minimumLimit: Int {
            get {
              return snapshot["minimumLimit"]! as! Int
            }
            set {
              snapshot.updateValue(newValue, forKey: "minimumLimit")
            }
          }
        }

        public struct Launch: GraphQLSelectionSet {
          public static let possibleTypes = ["Launch"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("soldOutAt", type: .scalar(String.self)),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(soldOutAt: String? = nil) {
            self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var soldOutAt: String? {
            get {
              return snapshot["soldOutAt"] as? String
            }
            set {
              snapshot.updateValue(newValue, forKey: "soldOutAt")
            }
          }
        }
      }
    }
  }
}

public final class OnCreateDealSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateDeal {\n  onCreateDeal {\n    __typename\n    id\n    dealID\n    dealYear\n    monthDay\n    title\n    features\n    specifications\n    url\n    createdAt\n    endDate\n    soldOutAt\n    items {\n      __typename\n      id\n      attributes {\n        __typename\n        key\n        value\n      }\n      condition\n      price\n      photo\n    }\n    modelNumbers\n    photos\n    story {\n      __typename\n      title\n      body\n    }\n    topic {\n      __typename\n      id\n      commentCount\n      createdAt\n      replyCount\n      url\n      voteCount\n    }\n    theme {\n      __typename\n      accentColor\n      backgroundColor\n      backgroundImage\n      foreground\n    }\n    purchaseQuantity {\n      __typename\n      maximumLimit\n      minimumLimit\n    }\n    launches {\n      __typename\n      soldOutAt\n    }\n    launchStatus\n    _version\n    _deleted\n    _lastChangedAt\n    updatedAt\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateDeal", type: .object(OnCreateDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateDeal: OnCreateDeal? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateDeal": onCreateDeal.flatMap { $0.snapshot }])
    }

    public var onCreateDeal: OnCreateDeal? {
      get {
        return (snapshot["onCreateDeal"] as? Snapshot).flatMap { OnCreateDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateDeal")
      }
    }

    public struct OnCreateDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["Deal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
        GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("features", type: .nonNull(.scalar(String.self))),
        GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("endDate", type: .scalar(String.self)),
        GraphQLField("soldOutAt", type: .scalar(String.self)),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("story", type: .object(Story.selections)),
        GraphQLField("topic", type: .object(Topic.selections)),
        GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
        GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
        GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
        GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
        self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var dealId: GraphQLID {
        get {
          return snapshot["dealID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealID")
        }
      }

      public var dealYear: String {
        get {
          return snapshot["dealYear"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealYear")
        }
      }

      public var monthDay: String {
        get {
          return snapshot["monthDay"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "monthDay")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var features: String {
        get {
          return snapshot["features"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "features")
        }
      }

      public var specifications: String {
        get {
          return snapshot["specifications"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "specifications")
        }
      }

      public var url: String {
        get {
          return snapshot["url"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var endDate: String? {
        get {
          return snapshot["endDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "endDate")
        }
      }

      public var soldOutAt: String? {
        get {
          return snapshot["soldOutAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "soldOutAt")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var modelNumbers: [String]? {
        get {
          return snapshot["modelNumbers"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "modelNumbers")
        }
      }

      public var photos: [String] {
        get {
          return snapshot["photos"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "photos")
        }
      }

      public var story: Story? {
        get {
          return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "story")
        }
      }

      public var topic: Topic? {
        get {
          return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "topic")
        }
      }

      public var theme: Theme {
        get {
          return Theme(snapshot: snapshot["theme"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "theme")
        }
      }

      public var purchaseQuantity: PurchaseQuantity? {
        get {
          return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
        }
      }

      public var launches: [Launch]? {
        get {
          return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
        }
      }

      public var launchStatus: LaunchStatus {
        get {
          return snapshot["launchStatus"]! as! LaunchStatus
        }
        set {
          snapshot.updateValue(newValue, forKey: "launchStatus")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Item"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("attributes", type: .nonNull(.list(.object(Attribute.selections)))),
          GraphQLField("condition", type: .nonNull(.scalar(String.self))),
          GraphQLField("price", type: .nonNull(.scalar(Double.self))),
          GraphQLField("photo", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, attributes: [Attribute?], condition: String, price: Double, photo: String) {
          self.init(snapshot: ["__typename": "Item", "id": id, "attributes": attributes.map { $0.flatMap { $0.snapshot } }, "condition": condition, "price": price, "photo": photo])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var attributes: [Attribute?] {
          get {
            return (snapshot["attributes"] as! [Snapshot?]).map { $0.flatMap { Attribute(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "attributes")
          }
        }

        public var condition: String {
          get {
            return snapshot["condition"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "condition")
          }
        }

        public var price: Double {
          get {
            return snapshot["price"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        public var photo: String {
          get {
            return snapshot["photo"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "photo")
          }
        }

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes = ["ItemAttribute"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("value", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, value: String) {
            self.init(snapshot: ["__typename": "ItemAttribute", "key": key, "value": value])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var value: String {
            get {
              return snapshot["value"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "value")
            }
          }
        }
      }

      public struct Story: GraphQLSelectionSet {
        public static let possibleTypes = ["Story"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("body", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(title: String, body: String) {
          self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var body: String {
          get {
            return snapshot["body"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }
      }

      public struct Topic: GraphQLSelectionSet {
        public static let possibleTypes = ["Topic"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
          self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var commentCount: Int {
          get {
            return snapshot["commentCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "commentCount")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var replyCount: Int {
          get {
            return snapshot["replyCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "replyCount")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var voteCount: Int {
          get {
            return snapshot["voteCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "voteCount")
          }
        }
      }

      public struct Theme: GraphQLSelectionSet {
        public static let possibleTypes = ["Theme"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundImage", type: .scalar(String.self)),
          GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
          self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var accentColor: String {
          get {
            return snapshot["accentColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "accentColor")
          }
        }

        public var backgroundColor: String {
          get {
            return snapshot["backgroundColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundColor")
          }
        }

        public var backgroundImage: String? {
          get {
            return snapshot["backgroundImage"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundImage")
          }
        }

        public var foreground: ThemeForeground {
          get {
            return snapshot["foreground"]! as! ThemeForeground
          }
          set {
            snapshot.updateValue(newValue, forKey: "foreground")
          }
        }
      }

      public struct PurchaseQuantity: GraphQLSelectionSet {
        public static let possibleTypes = ["PurchaseQuantity"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
          GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(maximumLimit: Int, minimumLimit: Int) {
          self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var maximumLimit: Int {
          get {
            return snapshot["maximumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "maximumLimit")
          }
        }

        public var minimumLimit: Int {
          get {
            return snapshot["minimumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "minimumLimit")
          }
        }
      }

      public struct Launch: GraphQLSelectionSet {
        public static let possibleTypes = ["Launch"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(soldOutAt: String? = nil) {
          self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }
      }
    }
  }
}

public final class OnUpdateDealSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateDeal {\n  onUpdateDeal {\n    __typename\n    id\n    dealID\n    dealYear\n    monthDay\n    title\n    features\n    specifications\n    url\n    createdAt\n    endDate\n    soldOutAt\n    items {\n      __typename\n      id\n      attributes {\n        __typename\n        key\n        value\n      }\n      condition\n      price\n      photo\n    }\n    modelNumbers\n    photos\n    story {\n      __typename\n      title\n      body\n    }\n    topic {\n      __typename\n      id\n      commentCount\n      createdAt\n      replyCount\n      url\n      voteCount\n    }\n    theme {\n      __typename\n      accentColor\n      backgroundColor\n      backgroundImage\n      foreground\n    }\n    purchaseQuantity {\n      __typename\n      maximumLimit\n      minimumLimit\n    }\n    launches {\n      __typename\n      soldOutAt\n    }\n    launchStatus\n    _version\n    _deleted\n    _lastChangedAt\n    updatedAt\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateDeal", type: .object(OnUpdateDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateDeal: OnUpdateDeal? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateDeal": onUpdateDeal.flatMap { $0.snapshot }])
    }

    public var onUpdateDeal: OnUpdateDeal? {
      get {
        return (snapshot["onUpdateDeal"] as? Snapshot).flatMap { OnUpdateDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateDeal")
      }
    }

    public struct OnUpdateDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["Deal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
        GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("features", type: .nonNull(.scalar(String.self))),
        GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("endDate", type: .scalar(String.self)),
        GraphQLField("soldOutAt", type: .scalar(String.self)),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("story", type: .object(Story.selections)),
        GraphQLField("topic", type: .object(Topic.selections)),
        GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
        GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
        GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
        GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
        self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var dealId: GraphQLID {
        get {
          return snapshot["dealID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealID")
        }
      }

      public var dealYear: String {
        get {
          return snapshot["dealYear"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealYear")
        }
      }

      public var monthDay: String {
        get {
          return snapshot["monthDay"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "monthDay")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var features: String {
        get {
          return snapshot["features"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "features")
        }
      }

      public var specifications: String {
        get {
          return snapshot["specifications"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "specifications")
        }
      }

      public var url: String {
        get {
          return snapshot["url"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var endDate: String? {
        get {
          return snapshot["endDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "endDate")
        }
      }

      public var soldOutAt: String? {
        get {
          return snapshot["soldOutAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "soldOutAt")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var modelNumbers: [String]? {
        get {
          return snapshot["modelNumbers"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "modelNumbers")
        }
      }

      public var photos: [String] {
        get {
          return snapshot["photos"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "photos")
        }
      }

      public var story: Story? {
        get {
          return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "story")
        }
      }

      public var topic: Topic? {
        get {
          return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "topic")
        }
      }

      public var theme: Theme {
        get {
          return Theme(snapshot: snapshot["theme"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "theme")
        }
      }

      public var purchaseQuantity: PurchaseQuantity? {
        get {
          return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
        }
      }

      public var launches: [Launch]? {
        get {
          return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
        }
      }

      public var launchStatus: LaunchStatus {
        get {
          return snapshot["launchStatus"]! as! LaunchStatus
        }
        set {
          snapshot.updateValue(newValue, forKey: "launchStatus")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Item"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("attributes", type: .nonNull(.list(.object(Attribute.selections)))),
          GraphQLField("condition", type: .nonNull(.scalar(String.self))),
          GraphQLField("price", type: .nonNull(.scalar(Double.self))),
          GraphQLField("photo", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, attributes: [Attribute?], condition: String, price: Double, photo: String) {
          self.init(snapshot: ["__typename": "Item", "id": id, "attributes": attributes.map { $0.flatMap { $0.snapshot } }, "condition": condition, "price": price, "photo": photo])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var attributes: [Attribute?] {
          get {
            return (snapshot["attributes"] as! [Snapshot?]).map { $0.flatMap { Attribute(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "attributes")
          }
        }

        public var condition: String {
          get {
            return snapshot["condition"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "condition")
          }
        }

        public var price: Double {
          get {
            return snapshot["price"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        public var photo: String {
          get {
            return snapshot["photo"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "photo")
          }
        }

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes = ["ItemAttribute"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("value", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, value: String) {
            self.init(snapshot: ["__typename": "ItemAttribute", "key": key, "value": value])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var value: String {
            get {
              return snapshot["value"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "value")
            }
          }
        }
      }

      public struct Story: GraphQLSelectionSet {
        public static let possibleTypes = ["Story"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("body", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(title: String, body: String) {
          self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var body: String {
          get {
            return snapshot["body"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }
      }

      public struct Topic: GraphQLSelectionSet {
        public static let possibleTypes = ["Topic"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
          self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var commentCount: Int {
          get {
            return snapshot["commentCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "commentCount")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var replyCount: Int {
          get {
            return snapshot["replyCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "replyCount")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var voteCount: Int {
          get {
            return snapshot["voteCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "voteCount")
          }
        }
      }

      public struct Theme: GraphQLSelectionSet {
        public static let possibleTypes = ["Theme"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundImage", type: .scalar(String.self)),
          GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
          self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var accentColor: String {
          get {
            return snapshot["accentColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "accentColor")
          }
        }

        public var backgroundColor: String {
          get {
            return snapshot["backgroundColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundColor")
          }
        }

        public var backgroundImage: String? {
          get {
            return snapshot["backgroundImage"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundImage")
          }
        }

        public var foreground: ThemeForeground {
          get {
            return snapshot["foreground"]! as! ThemeForeground
          }
          set {
            snapshot.updateValue(newValue, forKey: "foreground")
          }
        }
      }

      public struct PurchaseQuantity: GraphQLSelectionSet {
        public static let possibleTypes = ["PurchaseQuantity"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
          GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(maximumLimit: Int, minimumLimit: Int) {
          self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var maximumLimit: Int {
          get {
            return snapshot["maximumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "maximumLimit")
          }
        }

        public var minimumLimit: Int {
          get {
            return snapshot["minimumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "minimumLimit")
          }
        }
      }

      public struct Launch: GraphQLSelectionSet {
        public static let possibleTypes = ["Launch"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(soldOutAt: String? = nil) {
          self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }
      }
    }
  }
}

public final class OnDeleteDealSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteDeal {\n  onDeleteDeal {\n    __typename\n    id\n    dealID\n    dealYear\n    monthDay\n    title\n    features\n    specifications\n    url\n    createdAt\n    endDate\n    soldOutAt\n    items {\n      __typename\n      id\n      attributes {\n        __typename\n        key\n        value\n      }\n      condition\n      price\n      photo\n    }\n    modelNumbers\n    photos\n    story {\n      __typename\n      title\n      body\n    }\n    topic {\n      __typename\n      id\n      commentCount\n      createdAt\n      replyCount\n      url\n      voteCount\n    }\n    theme {\n      __typename\n      accentColor\n      backgroundColor\n      backgroundImage\n      foreground\n    }\n    purchaseQuantity {\n      __typename\n      maximumLimit\n      minimumLimit\n    }\n    launches {\n      __typename\n      soldOutAt\n    }\n    launchStatus\n    _version\n    _deleted\n    _lastChangedAt\n    updatedAt\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteDeal", type: .object(OnDeleteDeal.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteDeal: OnDeleteDeal? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteDeal": onDeleteDeal.flatMap { $0.snapshot }])
    }

    public var onDeleteDeal: OnDeleteDeal? {
      get {
        return (snapshot["onDeleteDeal"] as? Snapshot).flatMap { OnDeleteDeal(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteDeal")
      }
    }

    public struct OnDeleteDeal: GraphQLSelectionSet {
      public static let possibleTypes = ["Deal"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("dealYear", type: .nonNull(.scalar(String.self))),
        GraphQLField("monthDay", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("features", type: .nonNull(.scalar(String.self))),
        GraphQLField("specifications", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("endDate", type: .scalar(String.self)),
        GraphQLField("soldOutAt", type: .scalar(String.self)),
        GraphQLField("items", type: .nonNull(.list(.nonNull(.object(Item.selections))))),
        GraphQLField("modelNumbers", type: .list(.nonNull(.scalar(String.self)))),
        GraphQLField("photos", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
        GraphQLField("story", type: .object(Story.selections)),
        GraphQLField("topic", type: .object(Topic.selections)),
        GraphQLField("theme", type: .nonNull(.object(Theme.selections))),
        GraphQLField("purchaseQuantity", type: .object(PurchaseQuantity.selections)),
        GraphQLField("launches", type: .list(.nonNull(.object(Launch.selections)))),
        GraphQLField("launchStatus", type: .nonNull(.scalar(LaunchStatus.self))),
        GraphQLField("_version", type: .nonNull(.scalar(Int.self))),
        GraphQLField("_deleted", type: .scalar(Bool.self)),
        GraphQLField("_lastChangedAt", type: .nonNull(.scalar(Int.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, dealId: GraphQLID, dealYear: String, monthDay: String, title: String, features: String, specifications: String, url: String, createdAt: String, endDate: String? = nil, soldOutAt: String? = nil, items: [Item], modelNumbers: [String]? = nil, photos: [String], story: Story? = nil, topic: Topic? = nil, theme: Theme, purchaseQuantity: PurchaseQuantity? = nil, launches: [Launch]? = nil, launchStatus: LaunchStatus, version: Int, deleted: Bool? = nil, lastChangedAt: Int, updatedAt: String) {
        self.init(snapshot: ["__typename": "Deal", "id": id, "dealID": dealId, "dealYear": dealYear, "monthDay": monthDay, "title": title, "features": features, "specifications": specifications, "url": url, "createdAt": createdAt, "endDate": endDate, "soldOutAt": soldOutAt, "items": items.map { $0.snapshot }, "modelNumbers": modelNumbers, "photos": photos, "story": story.flatMap { $0.snapshot }, "topic": topic.flatMap { $0.snapshot }, "theme": theme.snapshot, "purchaseQuantity": purchaseQuantity.flatMap { $0.snapshot }, "launches": launches.flatMap { $0.map { $0.snapshot } }, "launchStatus": launchStatus, "_version": version, "_deleted": deleted, "_lastChangedAt": lastChangedAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var dealId: GraphQLID {
        get {
          return snapshot["dealID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealID")
        }
      }

      public var dealYear: String {
        get {
          return snapshot["dealYear"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "dealYear")
        }
      }

      public var monthDay: String {
        get {
          return snapshot["monthDay"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "monthDay")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var features: String {
        get {
          return snapshot["features"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "features")
        }
      }

      public var specifications: String {
        get {
          return snapshot["specifications"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "specifications")
        }
      }

      public var url: String {
        get {
          return snapshot["url"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "url")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var endDate: String? {
        get {
          return snapshot["endDate"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "endDate")
        }
      }

      public var soldOutAt: String? {
        get {
          return snapshot["soldOutAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "soldOutAt")
        }
      }

      public var items: [Item] {
        get {
          return (snapshot["items"] as! [Snapshot]).map { Item(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue.map { $0.snapshot }, forKey: "items")
        }
      }

      public var modelNumbers: [String]? {
        get {
          return snapshot["modelNumbers"] as? [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "modelNumbers")
        }
      }

      public var photos: [String] {
        get {
          return snapshot["photos"]! as! [String]
        }
        set {
          snapshot.updateValue(newValue, forKey: "photos")
        }
      }

      public var story: Story? {
        get {
          return (snapshot["story"] as? Snapshot).flatMap { Story(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "story")
        }
      }

      public var topic: Topic? {
        get {
          return (snapshot["topic"] as? Snapshot).flatMap { Topic(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "topic")
        }
      }

      public var theme: Theme {
        get {
          return Theme(snapshot: snapshot["theme"]! as! Snapshot)
        }
        set {
          snapshot.updateValue(newValue.snapshot, forKey: "theme")
        }
      }

      public var purchaseQuantity: PurchaseQuantity? {
        get {
          return (snapshot["purchaseQuantity"] as? Snapshot).flatMap { PurchaseQuantity(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "purchaseQuantity")
        }
      }

      public var launches: [Launch]? {
        get {
          return (snapshot["launches"] as? [Snapshot]).flatMap { $0.map { Launch(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.flatMap { $0.map { $0.snapshot } }, forKey: "launches")
        }
      }

      public var launchStatus: LaunchStatus {
        get {
          return snapshot["launchStatus"]! as! LaunchStatus
        }
        set {
          snapshot.updateValue(newValue, forKey: "launchStatus")
        }
      }

      public var version: Int {
        get {
          return snapshot["_version"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_version")
        }
      }

      public var deleted: Bool? {
        get {
          return snapshot["_deleted"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "_deleted")
        }
      }

      public var lastChangedAt: Int {
        get {
          return snapshot["_lastChangedAt"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "_lastChangedAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Item"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("attributes", type: .nonNull(.list(.object(Attribute.selections)))),
          GraphQLField("condition", type: .nonNull(.scalar(String.self))),
          GraphQLField("price", type: .nonNull(.scalar(Double.self))),
          GraphQLField("photo", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, attributes: [Attribute?], condition: String, price: Double, photo: String) {
          self.init(snapshot: ["__typename": "Item", "id": id, "attributes": attributes.map { $0.flatMap { $0.snapshot } }, "condition": condition, "price": price, "photo": photo])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var attributes: [Attribute?] {
          get {
            return (snapshot["attributes"] as! [Snapshot?]).map { $0.flatMap { Attribute(snapshot: $0) } }
          }
          set {
            snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "attributes")
          }
        }

        public var condition: String {
          get {
            return snapshot["condition"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "condition")
          }
        }

        public var price: Double {
          get {
            return snapshot["price"]! as! Double
          }
          set {
            snapshot.updateValue(newValue, forKey: "price")
          }
        }

        public var photo: String {
          get {
            return snapshot["photo"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "photo")
          }
        }

        public struct Attribute: GraphQLSelectionSet {
          public static let possibleTypes = ["ItemAttribute"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("value", type: .nonNull(.scalar(String.self))),
          ]

          public var snapshot: Snapshot

          public init(snapshot: Snapshot) {
            self.snapshot = snapshot
          }

          public init(key: String, value: String) {
            self.init(snapshot: ["__typename": "ItemAttribute", "key": key, "value": value])
          }

          public var __typename: String {
            get {
              return snapshot["__typename"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "__typename")
            }
          }

          public var key: String {
            get {
              return snapshot["key"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "key")
            }
          }

          public var value: String {
            get {
              return snapshot["value"]! as! String
            }
            set {
              snapshot.updateValue(newValue, forKey: "value")
            }
          }
        }
      }

      public struct Story: GraphQLSelectionSet {
        public static let possibleTypes = ["Story"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("body", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(title: String, body: String) {
          self.init(snapshot: ["__typename": "Story", "title": title, "body": body])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var body: String {
          get {
            return snapshot["body"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }
      }

      public struct Topic: GraphQLSelectionSet {
        public static let possibleTypes = ["Topic"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("commentCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("replyCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteCount", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, commentCount: Int, createdAt: String, replyCount: Int, url: String, voteCount: Int) {
          self.init(snapshot: ["__typename": "Topic", "id": id, "commentCount": commentCount, "createdAt": createdAt, "replyCount": replyCount, "url": url, "voteCount": voteCount])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var commentCount: Int {
          get {
            return snapshot["commentCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "commentCount")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var replyCount: Int {
          get {
            return snapshot["replyCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "replyCount")
          }
        }

        public var url: String {
          get {
            return snapshot["url"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "url")
          }
        }

        public var voteCount: Int {
          get {
            return snapshot["voteCount"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "voteCount")
          }
        }
      }

      public struct Theme: GraphQLSelectionSet {
        public static let possibleTypes = ["Theme"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accentColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundColor", type: .nonNull(.scalar(String.self))),
          GraphQLField("backgroundImage", type: .scalar(String.self)),
          GraphQLField("foreground", type: .nonNull(.scalar(ThemeForeground.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(accentColor: String, backgroundColor: String, backgroundImage: String? = nil, foreground: ThemeForeground) {
          self.init(snapshot: ["__typename": "Theme", "accentColor": accentColor, "backgroundColor": backgroundColor, "backgroundImage": backgroundImage, "foreground": foreground])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var accentColor: String {
          get {
            return snapshot["accentColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "accentColor")
          }
        }

        public var backgroundColor: String {
          get {
            return snapshot["backgroundColor"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundColor")
          }
        }

        public var backgroundImage: String? {
          get {
            return snapshot["backgroundImage"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "backgroundImage")
          }
        }

        public var foreground: ThemeForeground {
          get {
            return snapshot["foreground"]! as! ThemeForeground
          }
          set {
            snapshot.updateValue(newValue, forKey: "foreground")
          }
        }
      }

      public struct PurchaseQuantity: GraphQLSelectionSet {
        public static let possibleTypes = ["PurchaseQuantity"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("maximumLimit", type: .nonNull(.scalar(Int.self))),
          GraphQLField("minimumLimit", type: .nonNull(.scalar(Int.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(maximumLimit: Int, minimumLimit: Int) {
          self.init(snapshot: ["__typename": "PurchaseQuantity", "maximumLimit": maximumLimit, "minimumLimit": minimumLimit])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var maximumLimit: Int {
          get {
            return snapshot["maximumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "maximumLimit")
          }
        }

        public var minimumLimit: Int {
          get {
            return snapshot["minimumLimit"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "minimumLimit")
          }
        }
      }

      public struct Launch: GraphQLSelectionSet {
        public static let possibleTypes = ["Launch"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("soldOutAt", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(soldOutAt: String? = nil) {
          self.init(snapshot: ["__typename": "Launch", "soldOutAt": soldOutAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var soldOutAt: String? {
          get {
            return snapshot["soldOutAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "soldOutAt")
          }
        }
      }
    }
  }
}
