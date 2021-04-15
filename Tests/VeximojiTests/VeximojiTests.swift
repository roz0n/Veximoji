import XCTest
@testable import Veximoji

final class VeximojiTests: XCTestCase {
  
  let codes = CFLocaleCopyISOCountryCodes() as! Array<String>
  var validCountryCode: String?
  var invalidCountryCode: String?
  
  // MARK: - Test Helpers
  
  func getRandomCountryCode() {
    validCountryCode = codes[Int.random(in: 0..<codes.count)]
  }
  
  func generateRandomInvalidCode() {
    var randomString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    randomString = String(randomString.prefix(2))
    
    // Ensure a valid code is not randomly generated
    if codes.contains(randomString) {
      generateRandomInvalidCode()
    } else {
      invalidCountryCode = randomString
    }
  }
  
  // MARK: - Test Lifecycle
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    // Get a random country code from `CFLocaleCopyISOCountryCodes`
    getRandomCountryCode()
    
    // Generate a random two char string
    generateRandomInvalidCode()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    
    // Reset values
    validCountryCode = nil
    invalidCountryCode = nil
  }
  
  // MARK: - Unit Tests
  
  func testsCulturalTermScalars() {
    // Ensures each term has an array of scalars
    for term in Veximoji.CulturalTerms.allCases {
      let scalars = Veximoji.culturalTermScalars[term]
      
      XCTAssertFalse(scalars == nil,
                     "Each cultural term has an associated entry in the scalars dictionary")
      XCTAssertFalse(scalars!.isEmpty,
                     "Each entry in the scalars dictionary is populated")
    }
  }
  
  func testsISO3166Validation() {
    XCTAssertTrue(Veximoji.validateISO3166(code: validCountryCode!),
                  "Returns true when a valid country code is given")
    XCTAssertTrue(Veximoji.validateISO3166(code: validCountryCode!.lowercased()),
                  "Returns true when a valid lowercased country code is given")
    XCTAssertFalse(Veximoji.validateISO3166(code: invalidCountryCode!),
                   "Returns false when an invalid country code is given")
  }
  
  func testsCountryFlagEmoji() {
    let output = Veximoji.country(code: validCountryCode!)
    let lowercasedOutput = Veximoji.country(code: validCountryCode!.lowercased())
    let nilOutput = Veximoji.country(code: invalidCountryCode!)
    
    XCTAssertTrue(output!.unicodeScalars.first!.properties.isEmoji,
                  "Returns an emoji when a valid country code is given")
    XCTAssertTrue(lowercasedOutput!.unicodeScalars.first!.properties.isEmoji,
                  "Returns an emoji when a valid lowercased country code is given")
    XCTAssertTrue(nilOutput == nil,
                  "Returns nil when an invalid country code is given.")
  }
  
  func testsCulturalFlagEmoji() {
    let term: Veximoji.CulturalTerms = .pirate
    let output = Veximoji.cultural(term: .pirate)
    
    XCTAssertTrue(type(of: term) == Veximoji.CulturalTerms.self)
    XCTAssertTrue(output!.unicodeScalars.first!.properties.isEmoji,
                  "Returns an emoji when a valid country code is given")
  }
  
}
