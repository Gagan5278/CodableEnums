import UIKit

/*
 Mutually exlusive events handling
 */

enum Test<A, B> {
    case first(A)
    case second(B)
}

extension Test: Codable where A: Codable, B: Codable {
    private enum Key: CodingKey {
        case first
        case second
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        do {
            let first = try container.decode(A.self, forKey: .first)
            self = .first(first)
        }
        catch {
            let second = try container.decode(B.self, forKey: .second)
            self = .second(second)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container =  encoder.container(keyedBy: Key.self)
        switch self {
        case .first(let first):
            try container.encode(first, forKey: .first)
        case .second(let second):
            try container.encode(second, forKey: .second)
        }
    }
}

//MARK:- Uses

let items:[Test<String, Int>] = [
.first("Gagan"),
.second(31)
]
let itemsData =  try JSONEncoder().encode(items)

//1. Encoding
let itemsJSON = String(data: itemsData, encoding: .utf8)
print("Encoding :\(String(describing: itemsJSON))")

//2. Decoding
do {
    let realItems = try JSONDecoder().decode([Test<String, Int>].self, from: itemsData)
    print("Decoding :\(realItems.count)")
}
catch {
    print("Decoding Error : \(error)")
}
