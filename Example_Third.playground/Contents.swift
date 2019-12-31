import UIKit


enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var upcCode = Barcode.upc(1, 2, 3, 4)
upcCode = .qrCode("Hello")

switch upcCode {
case .qrCode(let string):
    print(string)
case .upc(_, _, let r, _):
        print(r)
}

enum Planet: Int, Codable {
    case mercury = 1, venus, earth, jupiter, saturn, uranus, neptune
}

let mars = Planet.mercury
UserDefaults.standard.setValue(mars.rawValue, forKey: "mars")
if let objectData  = try? JSONEncoder().encode(Planet.mercury) {
    print(objectData)
    if let rawValue = try? JSONDecoder().decode(Int.self, from: objectData) {
        print(Planet(rawValue: rawValue) as Any)
    }
}



//ENUM Confirming Codable
enum CodableBarcode: Codable {
    case upc
    case qrCode
    private enum CodingKeys: CodingKey {
        case rawValue
    }
    
    private enum CodingError: Error {
        case customError
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue  = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .upc
        case 1:
            self = .qrCode
        default:
            throw CodingError.customError
        }
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .upc:
            try container.encode(0, forKey: .rawValue)
        default:
            try container.encode(1, forKey: .rawValue)
        }
    }
}

let qrCode =  CodableBarcode.qrCode

let itemData =  try JSONEncoder().encode(qrCode)
    
let json = try JSONDecoder().decode(CodableBarcode.self, from: itemData)
print(json)


enum CodableBarcodeWithCorrespondingEnum: Codable {
    case upc
    case qrCode
    private enum CodingKeys: CodingKey {
        case upc
        case qrCode
    }
        
    private enum CodingError: Error {
        case customError
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let _  = try? container.decode(Int.self, forKey: .qrCode) {
            self = .qrCode
            return
        }
        if let _ = try? container.decode(Int.self, forKey: .upc) {
            self = .upc
            return
        }
        throw CodingError.customError
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .upc:
            try container.encode(true, forKey: .upc)
        case .qrCode:
            try container.encode(true, forKey: .upc)
        }
    }
}

//
enum CodableBarcodeWithAssociatedValues: Codable {
    case upc(Int)
    case qrCode(String)
    
    private enum CodingKeys: CodingKey {
        case upc
        case qrCode
    }
    
    private enum CodingError: Error {
        case customError
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value =  try? container.decode(Int.self, forKey: .upc) {
            self = .upc(value)
            return
        }
        if let value =  try? container.decode(String.self, forKey: .qrCode) {
            self = .qrCode(value)
            return
        }
        
        throw  CodingError.customError
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .upc(let value):
            try container.encode(value, forKey: .upc)
        case .qrCode(let value):
            try container.encode(value, forKey: .qrCode)
        }
    }
}

let item  = CodableBarcodeWithAssociatedValues.upc(12324)
let data = try JSONEncoder().encode(item)
let jsonValue = try JSONDecoder().decode(CodableBarcodeWithAssociatedValues.self, from: data)
print(jsonValue)

//MARK:---------Handling multiple values
enum State: Codable {
    case started
    case storeAtFile(path: String)
    case uploadFrom(path: String, percentage: CGFloat)
    
    private enum CodingKeys: CodingKey {
        case started
        case storeAtFile
        case uploadFrom, percentage
    }
    
    private enum CodingError: Error {
        case customError
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let _ = try? container.decode(Bool.self, forKey: .started) {
            self = .started
            return
        }
        if let value  = try? container.decode(String.self, forKey: .storeAtFile) {
            self = .storeAtFile(path: value)
            return
        }
        if let path =  try? container.decode(String.self, forKey: .uploadFrom), let percentage = try? container.decode(CGFloat.self, forKey: .percentage){
            self = .uploadFrom(path: path, percentage: percentage)
            return
        }
        throw CodingError.customError
    }
    
    func encode(to encoder: Encoder) throws {
        var container =  encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .started:
            try container.encode(true, forKey: .started)
        case .storeAtFile(let path):
            try container.encodeIfPresent(path, forKey: .storeAtFile)
        case .uploadFrom(let path, let percentage):
            try container.encodeIfPresent(path, forKey: .uploadFrom)
            try container.encodeIfPresent(percentage, forKey: .percentage)
        }
    }
}

let stateObject = State.uploadFrom(path: "my/path/upload", percentage: 0.33)
let stateData = try JSONEncoder().encode(stateObject)
let jsonObject = try JSONSerialization.jsonObject(with: stateData, options: .mutableLeaves)
print("jsonObject :\(jsonObject)")

if let decoder = try? JSONDecoder().decode(State.self, from: stateData) {
    switch decoder {
    case .started:
        print("started")
    case .storeAtFile(let path):
        print("Path is :\(path)")
    case .uploadFrom(let path, let percentage):
        print("Path is :\(path) and percentage :\(percentage)")
    }
}


