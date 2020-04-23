//
//  MehSyncAPIStub.swift
//  AdequateUITests
//
//  Created by Mathew Gacy on 4/19/20.
//  Copyright © 2020 Mathew Gacy. All rights reserved.
//

import Swifter

class GraphQLQueryParser {

    let pattern = #"""
    query\s
    (?<queryName>[a-zA-Z0-9]*)
    \(
    (?<arguments>[^{()]*)
    \)\s\{\R*\s*
    (?<a>.*?)
    \s*\{\R\s*
    (?<fields>(.*\R)*)
    \}
    """#

    let regexOptions: NSRegularExpression.Options = [.allowCommentsAndWhitespace]

    func parseQueryName(from jsonString: String) throws -> NamedQuery? {
        let jsonData = jsonString.data(using: .utf8)!
        guard
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any],
            let queryString = jsonObject["query"] as? String
            //let queryVariables = jsonObject["variables"] as? [String: Any]
        else {
            return nil
        }

        let regex = try NSRegularExpression(pattern: pattern, options: regexOptions)
        guard
            let match = regex.firstMatch(in: queryString, range: NSRange(queryString.startIndex..., in: queryString)),
            let nameSubString = queryString.substring(with: match.range(withName: "queryName")) else {
                return nil
        }

        // TODO: add the following as associated values on NamedQuery?
        //let queryArguments = String(describing: queryString.substring(with: match.range(withName: "arguments")))
        //let fields = String(describing: queryString.substring(with: match.range(withName: "fields")))

        switch String(describing: nameSubString) {
        case NamedQuery.getDeal.description:
            return NamedQuery.getDeal
        case NamedQuery.historyList.description:
            return NamedQuery.historyList
        default:
            return nil
        }
    }

    // MARK: - Types

    // TODO: add assocaited values for query arguments
    enum NamedQuery: CustomStringConvertible {
        case getDeal
        case historyList

        // TODO: incorporate ResponseFile into this?

        var description: String {
            switch self {
            case .getDeal:
                return "GetDeal"
            case .historyList:
                return "ListDealsForPeriod"
            }
        }
    }
}

class MehSyncAPIStub {

    let server = HttpServer()

    let queryParser = GraphQLQueryParser()

    func stubGraphQL() {
        server.POST["/graphql"] = { [weak queryParser] request in
            guard
                let jsonString = String(bytes: request.body, encoding: .utf8),
                let query = try? queryParser?.parseQueryName(from: jsonString) else {
                    fatalError("Invalid query")
                    //return HttpResponse.badRequest(.text("Invalid query"))
            }
            // TODO: break the following out into separate method?
            var resource: ResponseResource
            switch query {
            case .getDeal:
                resource = .currentDeal
            case .historyList:
                resource = .historyList
            }

            let json = try! FileLoader.loadJSON(from: resource, in: .main)
            return HttpResponse.ok(.json(json))
        }
    }
}
