import Foundation

public struct Veximoji {
  
  // MARK: - Enums
  
  /**
   In this context, cultural term refers to an emoji flag that does not correspond to a country or region, but rather to a cultural reference, movement, or ideology.
   
   The cultural term enum does not contain raw values. Its usage within `Veximoji` depends on the [Veximoji.culturalTermScalars](x-source-tag://culturalTermScalars) member which maps each enum case to an array of `UInt32` integers.
   */
  /// - Tag: CulturalTerms
  public enum CulturalTerms: String, CaseIterable {
    case pride
    case trans
    case pirate
    case white
    case black
    case crossed
    case triangular
    case racing
  }
  
  /**
   [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) codes refer to codes for provinces or states of countries in [ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes). (e.g., `GB-ENG` is the ISO 3166-2 code for "England", which is a subdivision of `GB`, or "Great Britain")
   
   Public access to this enum is restricted. Use the [Veximoji.subdivisionCodes](x-source-tag://subdivisionCodes) computed property to obtain the its raw values.
   */
  private enum ISO3166_2: String, CaseIterable {
    case england = "GB-ENG"
    case wales = "GB-WLS"
    case scotland = "GB-SCT"
  }
  
  /**
   [Exceptional reservation codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Exceptional_reservations) are codes reserved at the request of countries, governments, and/or international organizations. (e.g. the reserved code `EU` is used to identify the "European Union")
   
   Public access to this enum is restricted. Use the [Veximoji.internationalCodes](x-source-tag://internationalCodes) computed property to obtain the its raw values.
   */
  private enum ExceptionalReservations: String, CaseIterable {
    case europe = "EU"
    case un = "UN"
  }
  
  /**
   Contains Unicode scalars for each case of the [Veximoji.culturalTermScalars](x-source-tag://culturalTermScalars) enum. Each scalar is a `UInt32` value that when sequentially appended to a string's `unicodeScalars` property composes the corresponding emoji flag.
   */
  /// - Tag: culturalTermScalars
  private static let culturalTermScalars: [CulturalTerms: [UInt32]] = [
    .pride: [UInt32(127987), UInt32(65039), UInt32(8205), UInt32(127752)],
    .trans: [UInt32(127987), UInt32(65039), UInt32(8205), UInt32(9895), UInt32(65039)],
    .pirate: [UInt32(127988), UInt32(8205), UInt32(9760), UInt32(65039)],
    .white: [UInt32(127987), UInt32(65039)],
    .black: [UInt32(127988)],
    .crossed: [UInt32(127884)],
    .triangular: [UInt32(128681)],
    .racing: [UInt32(127937)],
  ]
  
  private static let iso3166_2Scalars: [ISO3166_2.RawValue: [UInt32]] = [
    "GB-ENG": [UInt32(127988), UInt32(917607), UInt32(917602), UInt32(917605), UInt32(917614), UInt32(917607), UInt32(917631)],
    "GB-WLS": [UInt32(127988), UInt32(917607), UInt32(917602), UInt32(917623), UInt32(917612), UInt32(917619), UInt32(917631)],
    "GB-SCT": [UInt32(127988), UInt32(917607), UInt32(917602), UInt32(917619), UInt32(917603), UInt32(917620), UInt32(917631)]
  ]
  
  private static let exceptionalReservationScalars: [ExceptionalReservations.RawValue: [UInt32]] = [
    "EU": [UInt32(127466), UInt32(127482)],
    "UN": [UInt32(127482), UInt32(127475)],
  ]
  
  // MARK: - Computed Properties
  
  public static var countryCodes: [String] {
    get {
      return CFLocaleCopyISOCountryCodes() as! Array<String>
    }
  }
  
  /// - Tag: subdivisionCodes
  public static var subdivisionCodes: [String] {
    get {
      return ISO3166_2.allCases.map { $0.rawValue }
    }
  }
  
  /// - Tag: internationalCodes
  public static var internationalCodes: [String] {
    get {
      return ExceptionalReservations.allCases.map { $0.rawValue }
    }
  }
  
  public static var culturalTerms: [String] {
    get {
      return CulturalTerms.allCases.map { $0.rawValue }
    }
  }
  
  // MARK: - Helper Methods
  
  /**
   Returns a boolean indicating whether a given string is a valid ISO 3611 Alpha-2 country code.
   
   For more information on ISO 3611-1 country codes see [this Wikipedia article.](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
   
   For more information on supported country codes see the [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) page in the Apple Developer Documentation.
   
   - parameter code: A string representing an Alpha-2 country code, e.g. "US" for United States of America or "DO" for Dominican Republic.
   - returns: `Bool` Either `true` or `false` depending on whether or not the given country code is a member of Core Foundation's [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) collection.
   
   # Example #
   ```
   let dominicanRepublicCode = "do" // supports uppercase, lowercase, and mixed-case strings
   
   if Veximoji.validateISO3166_1(code: dominicanRepublicCode)  {
   print("That country code is valid!")
   } else {
   print("That code is invalid")
   }
   ```
   */
  /// - Tag: validateISO3166_1
  private static func validateISO3166_1(code countryCode: String) -> Bool {
    return countryCodes.contains(countryCode.uppercased())
  }
  
  private static func validateISO3166_2(code countryCode: String) -> Bool {
    return subdivisionCodes.contains(countryCode.uppercased())
  }
  
  private static func validateExceptionalReservation(code countryCode: String) -> Bool {
    return internationalCodes.contains(countryCode.uppercased())
  }
  
  // MARK: - Flag Emoji Methods
  
  /**
   Returns the corresponding emoji flag of a valid and legal ISO 3166 Alpha-2 country code.
   
   The provided country code is deemed valid if it is a member of [Core Foundation's](https://developer.apple.com/documentation/corefoundation) [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) collection. This condition is only met if [Veximoji.validateISO3166_1](x-source-tag://validateISO3166_1) returns `true` for the given country code.
   
   - parameter code: A string representing a country code, e.g. "US" for United States of America or "DO" for Dominican Republic.
   - returns: `String?` Either a string representing the emoji flag of the given ISO 3166 country code or `nil` if an invalid or illegal country code is provided.
   
   # Example #
   ```
   if let emojiFlag = Veximoji.country(code: "DO")  {
   print("The Dominican Flag: \(emojiFlag)")
   }
   ```
   */
  public static func country(code countryCode: String) -> String? {
    var resultString = ""
    
    if !validateISO3166_1(code: countryCode) {
      return nil
    } else {
      let worldFlagBaseScalar: UInt32 = 127397
      
      for scalar in countryCode.uppercased().unicodeScalars {
        let result = UnicodeScalar(worldFlagBaseScalar + scalar.value)!
        resultString.unicodeScalars.append(result)
      }
      
      return resultString
    }
  }
  
  public static func subdivision(code subdivisionCode: String) -> String? {
    guard validateISO3166_2(code: subdivisionCode) else { return nil }
    guard let scalars = iso3166_2Scalars[subdivisionCode.uppercased()] else { return nil }
    var result = ""
    
    scalars.forEach {
      guard let scalar = UnicodeScalar($0) else { return }
      result.unicodeScalars.append(scalar)
    }
    
    return result == "" ? nil : result
  }
  
  public static func international(code internationalCode: String) -> String? {
    guard validateExceptionalReservation(code: internationalCode) else { return nil }
    guard let scalars = exceptionalReservationScalars[internationalCode.uppercased()] else { return nil }
    var result = ""
    
    scalars.forEach {
      guard let scalar = UnicodeScalar($0) else { return }
      result.unicodeScalars.append(scalar)
    }
    
    return result == "" ? nil : result
  }
  
  /**
   Returns the corresponding emoji flag of a given cultural term associated with [Veximoji.CulturalTerms](x-source-tag://CulturalTerms).
   
   In this context, cultural term refers to an emoji flag that does not correspond to a country or region, but rather to a cultural reference, movement, or ideology. This method receives a cultural term and sequentially appends the corresponding scalars to a string and returns it.
   
   - parameter named: A valid case of [Veximoji.CulturalTerms](x-source-tag://CulturalTerms), e.g. `.pride` for the rainbow or "pride" flag or `.pirate` for the pirate flag or "Jolly Roger".
   - returns: `String?` Either a string representing the emoji flag of the cultural term or `nil` if an invalid or illegal term is provided.
   
   # Example #
   ```
   if let pirateEmojiFlag = Veximoji.cultural(named: .pirate)  {
   print("Jolly Roger": \(pirateEmojiFlag)")
   }
   ```
   */
  public static func cultural(term: CulturalTerms) -> String? {
    guard let flagScalars = culturalTermScalars[term] else { return nil }
    guard !flagScalars.isEmpty else { return nil }
    var resultString = ""
    
    for scalar in flagScalars {
      resultString.unicodeScalars.append(UnicodeScalar(scalar)!)
    }
    
    return resultString
  }
  
}
