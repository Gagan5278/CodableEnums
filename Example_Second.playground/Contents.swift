import UIKit

/*1. ********************************************************************************************/
/*
 Simple Enum
 */
enum User {
    case firstName
    case lastName
    case fullName
}

extension User: Codable {
    private enum Key: CodingKey {
        case myValue
    }
    
    private enum CodingError: Error {
        case customError
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .myValue)
        switch rawValue {
        case 0:
            self = .firstName
        case 1:
            self = .lastName
        case 2:
            self = .fullName
        default:
            throw CodingError.customError
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .firstName:
            try container.encode(0, forKey: .myValue)
        case .lastName:
            try container.encode(1, forKey: .myValue)
        case .fullName:
            try container.encode(2, forKey: .myValue)
        }
    }
}

//EXAMPLE 1:
let firstName = User.firstName
let firstNameData = try JSONEncoder().encode(firstName)
let firstNameJSON = String(data: firstNameData, encoding: .utf8)
print(firstNameJSON)

/*2. **************************************************************************************/
/*
 Enum with Associated type
 */

enum LoginUser {
    case firstName(String)
    case lastName(String)
}

extension LoginUser: Codable {
    private enum Key: CodingKey {
        case rawValue
        case assoiatedType
    }
    
    private enum CodingError: Error {
        case customEror
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            let firstName = try container.decode(String.self, forKey: .assoiatedType)
            self = .firstName(firstName)
        case 1:
            let lastName = try container.decode(String.self, forKey: .assoiatedType)
            self = .lastName(lastName)
        default:
            throw CodingError.customEror
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container =  encoder.container(keyedBy: Key.self)
        switch self {
        case .firstName(let firstName):
            try container.encode(0, forKey: .rawValue)
            try container.encode(firstName, forKey: .assoiatedType)
        case .lastName(let lastName):
            try container.encode(1, forKey: .rawValue)
            try container.encode(lastName, forKey: .assoiatedType)
        }
    }
}

//EXAMPLE 2:
let loginUser =  LoginUser.firstName("Gagan")
let loginUserData = try JSONEncoder().encode(loginUser)
let loginUserJSON = String(data: loginUserData, encoding: .utf8)
print(loginUserJSON)
/*3. **************************************************************************************/
/*
 Enum with optional values and Associated types
 */

enum  UserAuth {
    case firstName(String?)
    case lastName(String?)
}

extension UserAuth: Codable {
    private enum Key: CodingKey {
        case rawValue
        case associatedType
    }
    
    private enum CodingError: Error {
        case customError
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue  = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            let firstName = try container.decodeIfPresent(String.self, forKey: .associatedType)
            self = .firstName(firstName)
        case 1:
            let lastName = try container.decodeIfPresent(String.self, forKey: .associatedType)
            self = .lastName(lastName)
        default:
        throw CodingError.customError
      }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .firstName(let firstName):
            try container.encode(0, forKey: .rawValue)
            try container.encode(firstName, forKey: .associatedType)
        case .lastName(let lastName):
            try container.encode(1, forKey: .rawValue)
            try container.encode(lastName, forKey: .associatedType)
        }
    }
}
//EXAMPLE 3:
let userAuth =  UserAuth.firstName(nil)
let userAuthData = try JSONEncoder().encode(userAuth)
let userAuthJSON = String(data: userAuthData, encoding: .utf8)
print(userAuthJSON)
