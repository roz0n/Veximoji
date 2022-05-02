import XCTest
@testable import Veximoji

final class VeximojiTests: XCTestCase {
  
  // MARK: - Properties
  
  let countryCodes = Veximoji.countryCodes
  let subdvisionCodes = Veximoji.subdivisionCodes
  let internationalCodes = Veximoji.internationalCodes
  
  var validCountryCode: String?
  var validSubdivisonCode: String?
  var validInternationalCode: String?
  
  var invalidCode: String?
  
  // MARK: - Test Helpers
  
  func getRandomCountryCode() {
    validCountryCode = countryCodes[Int.random(in: 0..<countryCodes.count)]
  }
  
  func getRandomSubdivsionCode() {
    validSubdivisonCode = subdvisionCodes[Int.random(in: 0..<subdvisionCodes.count)]
  }
  
  func getRandomInternationalCode() {
    validInternationalCode = internationalCodes[Int.random(in: 0..<internationalCodes.count)]
  }
  
  func generateRandomInvalidCode() {
    var randomString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    randomString = String(randomString.prefix(2))
    
    // Ensure a valid code is not randomly generated
    if countryCodes.contains(randomString) {
      generateRandomInvalidCode()
    } else {
      invalidCode = randomString
    }
  }
  
  // MARK: - Test Lifecycle
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    // Get a random country code
    getRandomCountryCode()
    
    // Get a random subdivision code
    getRandomSubdivsionCode()
    
    // Get a random international code
    getRandomInternationalCode()
    
    // Generate a random two char string
    generateRandomInvalidCode()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    
    // Reset all values
    validCountryCode = nil
    validSubdivisonCode = nil
    validInternationalCode = nil
    invalidCode = nil
  }
  
  // MARK: - Unicode Scalars Tests
  
  func testsCulturalTermScalars() {
    // Ensures each term has an array of scalars
    for term in Veximoji.CulturalTerms.allCases {
      let scalars = Veximoji.culturalScalars[term]
      
      XCTAssertNotNil(scalars,
                      "Each cultural term has an associated entry in the scalars dictionary")
      XCTAssertFalse(scalars!.isEmpty,
                     "Each entry in the scalars dictionary is populated")
    }
  }
  
  // MARK: - Emoji Flag Tests
  
  func testsCulturalFlagEmoji() {
    let term: Veximoji.CulturalTerms = .pirate
    let validInput = Veximoji.cultural(term: .pirate)
    let nilInput = Veximoji.cultural(term: nil)
    let validInputScalars = validInput!.unicodeScalars.first!
    
    XCTAssertNotNil(validInputScalars)
    
    XCTAssertTrue(type(of: term) == Veximoji.CulturalTerms.self)
    XCTAssertTrue(validInputScalars.properties.isEmoji,
                  "Returns an emoji when a valid country code is given")
    
    XCTAssertNil(nilInput,
                 "Returns nil when nil is given")
  }
  
  func testsCountryFlagEmoji() {
    let validInput = Veximoji.country(code: validCountryCode)
    let lowercasedValidInput = Veximoji.country(code: validCountryCode?.lowercased())
    let invalidInput = Veximoji.country(code: invalidCode)
    let nilInput = Veximoji.country(code: nil)
    
    let validInputScalars = validInput!.unicodeScalars.first!
    let lowercasedValidInputScalars = lowercasedValidInput!.unicodeScalars.first!
    
    XCTAssertNotNil(validInputScalars)
    XCTAssertNotNil(lowercasedValidInputScalars)
    
    XCTAssertTrue(validInputScalars.properties.isEmoji,
                  "Returns an emoji when a valid country code is given")
    XCTAssertTrue(lowercasedValidInputScalars.properties.isEmoji,
                  "Returns an emoji when a valid lowercased country code is given")
    
    XCTAssertNil(invalidInput, "Returns nil when an invalid country code is given")
    XCTAssertNil(nilInput, "Returns nil when nil is given")
  }
  
  func testsSubdivisionFlagEmoji() {
    let validInput = Veximoji.subdivision(code: validSubdivisonCode)
    let lowercasedValidInput = Veximoji.subdivision(code: validSubdivisonCode?.lowercased())
    let invalidInput = Veximoji.subdivision(code: invalidCode)
    let nilInput = Veximoji.subdivision(code: nil)
    
    let validInputScalars = validInput!.unicodeScalars.first!
    let lowercasedValidInputScalars = lowercasedValidInput!.unicodeScalars.first!
    
    XCTAssertNotNil(validInputScalars)
    XCTAssertNotNil(lowercasedValidInputScalars)
    
    XCTAssertTrue(validInputScalars.properties.isEmoji,
                  "Returns an emoji when a valid country code is given")
    XCTAssertTrue(lowercasedValidInputScalars.properties.isEmoji,
                  "Returns an emoji when a valid lowercased country code is given")
    
    XCTAssertNil(invalidInput, "Returns nil when an invalid code is given")
    XCTAssertNil(nilInput, "Returns nil when nil is given")
  }
  
  func testsInternationalFlagEmoji() {
    let validInput = Veximoji.international(code: validInternationalCode)
    let lowercasedValidInput = Veximoji.international(code: validInternationalCode?.lowercased())
    let invalidInput = Veximoji.international(code: invalidCode)
    let nilInput = Veximoji.international(code: nil)
    
    let validInputScalars = validInput!.unicodeScalars.first!
    let lowercasedValidInputScalars = lowercasedValidInput!.unicodeScalars.first!
    
    XCTAssertNotNil(validInputScalars)
    XCTAssertNotNil(lowercasedValidInputScalars)
    
    XCTAssertTrue(validInputScalars.properties.isEmoji,
                  "Returns an emoji when a valid international code is given")
    XCTAssertTrue(lowercasedValidInputScalars.properties.isEmoji,
                  "Returns an emoji when a valid lowercased international code is given")
    
    XCTAssertNil(invalidInput, "Returns nil when an invalid code is given")
    XCTAssertNil(nilInput, "Returns nil when an invalid code is given")
  }
  
  // MARK: - Validation Tests
  
  func testsISO3166_1Validation() {
    XCTAssertNotNil(validCountryCode)
    XCTAssertNotNil(invalidCode)
    
    XCTAssertTrue(Veximoji.validateISO3166_1(code: validCountryCode!),
                  "Returns true when a valid country code is given")
    XCTAssertTrue(Veximoji.validateISO3166_1(code: validCountryCode!.lowercased()),
                  "Returns true when a valid lowercased country code is given")
    XCTAssertFalse(Veximoji.validateISO3166_1(code: invalidCode!),
                   "Returns false when an invalid code is given")
  }
  
  func testsISO3166_2Validation() {
    XCTAssertNotNil(validSubdivisonCode)
    XCTAssertNotNil(invalidCode)
    
    XCTAssertTrue(Veximoji.validateISO3166_2(code: validSubdivisonCode!),
                  "Returns true when a valid subdivision code is given")
    XCTAssertTrue(Veximoji.validateISO3166_2(code: validSubdivisonCode!.lowercased()),
                  "Returns true when a valid lowercased subdivision code is given")
    XCTAssertFalse(Veximoji.validateISO3166_2(code: invalidCode!),
                   "Returns false when an invalid code is given")
  }
  
  func testsExceptionalReservationValidation() {
    XCTAssertNotNil(validInternationalCode)
    XCTAssertNotNil(invalidCode)
    
    XCTAssertTrue(Veximoji.validateExceptionalReservation(code: validInternationalCode!),
                  "Returns true when a valid international code is given")
    XCTAssertTrue(Veximoji.validateExceptionalReservation(code: validInternationalCode!.lowercased()), "Returns true when a valid lowercased international code is given")
    XCTAssertFalse(Veximoji.validateExceptionalReservation(code: invalidCode!),
                   "Returns false when an invalid code is given")
  }
  
}
