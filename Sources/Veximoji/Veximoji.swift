import Foundation

/// Used to represent an emoji flag category. In the context of `Veximoji`, this class used internally to represent each case of the [Veximoji.FlagCategories](x-source-tag://FlagCategories) enum when calling [Veximoji.getFlag](x-source-tag://getFlag).
/// - Tag: FlagCategory
fileprivate class FlagCategory {
  let type: Veximoji.FlagCategories
  let validator: ((_: String) -> Bool)?
  let scalars: [String: [UInt32]]?
  
  init(type: Veximoji.FlagCategories, validator: ((_: String) -> Bool)?, scalars: [String: [UInt32]]?) {
    self.type = type
    self.validator = validator ?? nil
    self.scalars = scalars ?? nil
  }
}

public struct Veximoji {
  
  // MARK: - Enums
  
  /// An enum representing each emoji flag category.
  /// - Tag: FlagCategories
  public enum FlagCategories: String, CaseIterable {
    case country = "country"
    case subdivision = "subdivision"
    case international = "international"
    case cultural = "cultural"
  }
  
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
   [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) codes refer to codes for provinces or states of countries in [ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes). (e.g., "GB-ENG" is the code for England, which is a subdivision of "GB", or Great Britain)
   
   Public access to this enum is restricted. Use the [Veximoji.subdivisionCodes](x-source-tag://subdivisionCodes) computed property to obtain its raw values.
   */
  /// - Tag: ISO3166_2
  fileprivate enum ISO3166_2: String, CaseIterable {
    case england = "GB-ENG"
    case wales = "GB-WLS"
    case scotland = "GB-SCT"
  }
  
  /**
   [Exceptional reservation codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Exceptional_reservations) are codes reserved at the request of countries, governments, and/or international organizations. (e.g. the reserved code `EU` is used to identify the "European Union")
   
   Public access to this enum is restricted. Use the [Veximoji.internationalCodes](x-source-tag://internationalCodes) computed property to obtain its raw values.
   */
  /// - Tag: ExceptionalReservations
  fileprivate enum ExceptionalReservations: String, CaseIterable {
    case europe = "EU"
    case un = "UN"
  }
  
  /**
   Contains Unicode scalars for each case of the [Veximoji.CulturalTerms](x-source-tag://CulturalTerms) enum. Each scalar is a `UInt32` value that when sequentially appended to a string's `unicodeScalars` property composes the corresponding emoji flag.
   
   Public access to this dictionary is restricted. To access the scalars of a particular emoji flag, use the `unicodeScalars` property of its string.
   */
  /// - Tag: culturalTermScalars
  fileprivate static let culturalTermScalars: [CulturalTerms: [UInt32]] = [
    .pride: [UInt32(127987), UInt32(65039), UInt32(8205), UInt32(127752)],
    .trans: [UInt32(127987), UInt32(65039), UInt32(8205), UInt32(9895), UInt32(65039)],
    .pirate: [UInt32(127988), UInt32(8205), UInt32(9760), UInt32(65039)],
    .white: [UInt32(127987), UInt32(65039)],
    .black: [UInt32(127988)],
    .crossed: [UInt32(127884)],
    .triangular: [UInt32(128681)],
    .racing: [UInt32(127937)],
  ]
  
  /**
   Contains Unicode scalars for each case of the [Veximoji.ISO3166_2](x-source-tag://ISO3166_2) enum. Each scalar is a `UInt32` value that when sequentially appended to a string's `unicodeScalars` property composes the corresponding emoji flag.
   
   Public access to this dictionary is restricted. To access the scalars of a particular emoji flag, use the `unicodeScalars` property of its string.
   */
  fileprivate static let iso3166_2Scalars: [ISO3166_2.RawValue: [UInt32]] = [
    "GB-ENG": [UInt32(127988), UInt32(917607), UInt32(917602), UInt32(917605), UInt32(917614), UInt32(917607), UInt32(917631)],
    "GB-WLS": [UInt32(127988), UInt32(917607), UInt32(917602), UInt32(917623), UInt32(917612), UInt32(917619), UInt32(917631)],
    "GB-SCT": [UInt32(127988), UInt32(917607), UInt32(917602), UInt32(917619), UInt32(917603), UInt32(917620), UInt32(917631)]
  ]
  
  /**
   Contains Unicode scalars for each case of the [Veximoji.ExceptionalReservations](x-source-tag://ExceptionalReservations) enum. Each scalar is a `UInt32` value that when sequentially appended to a string's `unicodeScalars` property composes the corresponding emoji flag.
   
   Public access to this dictionary is restricted. To access the scalars of a particular emoji flag, use the `unicodeScalars` property of its string.
   */
  private static let exceptionalReservationScalars: [ExceptionalReservations.RawValue: [UInt32]] = [
    "EU": [UInt32(127466), UInt32(127482)],
    "UN": [UInt32(127482), UInt32(127475)],
  ]
  
  // MARK: - Computed Properties
  
  /**
   Computes and returns all supported [ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) country codes.
   
   A country code is supported if it is a member of [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes).
   */
  public static var countryCodes: [String] {
    get {
      return CFLocaleCopyISOCountryCodes() as! Array<String>
    }
  }
  
  /**
   Computes and returns all supported [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) subdivision codes.
   
   For more information on subdivision codes see [this Wikipedia article](https://en.wikipedia.org/wiki/ISO_3166-2).
   */
  /// - Tag: subdivisionCodes
  public static var subdivisionCodes: [String] {
    get {
      return ISO3166_2.allCases.map { $0.rawValue }
    }
  }
  
  /**
   Computes and returns all supported exceptionally reserved [ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) codes.
   
   For more information on exceptionally reserved codes see [this Wikipedia article](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Exceptional_reservations).
   */
  /// - Tag: internationalCodes
  public static var internationalCodes: [String] {
    get {
      return ExceptionalReservations.allCases.map { $0.rawValue }
    }
  }
  
  /**
   Computes and returns raw values of all [Veximoji.CulturalTerms](x-source-tag://CulturalTerms) enum cases.
   */
  public static var culturalTerms: [String] {
    get {
      return CulturalTerms.allCases.map { $0.rawValue }
    }
  }
  
  public static var culturalScalars: [CulturalTerms: [UInt32]] {
    get {
      return culturalTermScalars
    }
  }
  
  // MARK: -
  
  /// Used internally to create and return an emoji flag based on the `type` property of the given [Veximoji.FlagCategory](x-source-tag://FlagCategory).
  /// - Parameters:
  ///   - category: A class that inherits from [Veximoji.FlagCategory](x-source-tag://FlagCategory)
  ///   - query: A unique indentifier for a specific flag (e.g., a ISO 3166 alpha-2 country or reserved code, an ISO 3166-2 subdivision code, or a case of the [Veximoji.CulturalTerms](x-source-tag://CulturalTerms) enum).
  /// - Returns: `Bool` Either a string containing the corresponding flag emoji, or `nil`.
  /// - Tag: getFlag
  private static func getFlag<T: FlagCategory>(category: T, query: String) -> String? {
    var emojiString = ""
    
    if let validator = category.validator {
      guard validator(query) else { return nil }
    }
    
    switch category.type {
      case .subdivision, .international:
        guard let scalars = category.scalars?[query.uppercased()] else { return nil }
        guard !scalars.isEmpty else { return nil }
        
        for scalar in scalars {
          if let scalar = UnicodeScalar(scalar) {
            emojiString.unicodeScalars.append(scalar)
          } else {
            return nil
          }
        }
        
        return emojiString
      case .country:
        let baseValue: UInt32 = 127397
        
        for scalar in query.uppercased().unicodeScalars {
          if let toAppend = UnicodeScalar(baseValue + scalar.value) {
            emojiString.unicodeScalars.append(toAppend)
          }
        }
        
        return emojiString
      case .cultural:
        guard let scalars = category.scalars else { return nil }
        guard let values = scalars[query] else { return nil }
        guard !values.isEmpty else { return nil }
        
        for scalar in values {
          if let scalar = UnicodeScalar(scalar) {
            emojiString.unicodeScalars.append(scalar)
          }
        }
        
        return emojiString
    }
  }
  
  // MARK: - Helper Methods
  
  /**
   Returns a boolean indicating whether a given string is a valid country code.
   
   For more information on ISO 3166-1 country codes see [this Wikipedia article.](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
   
   For more information on supported country codes see the [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) page in the Apple Developer Documentation.
   
   - parameter code: A string representing an ISO 3166-1 alpha-2 country code (e.g. "US" for United States of America or "DO" for Dominican Republic)
   - returns: `Bool` Whether or not the given subdivision code is a member of Core Foundation's [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) collection.
   
   # Example #
   ```
   let dominicanRepublicCode = "do" // supports uppercase, lowercase, and mixed-case strings
   
   if Veximoji.validateISO3166_1(code: dominicanRepublicCode)  {
    print("That country code is valid")
   } else {
    print("That country code is invalid")
   }
   ```
   */
  /// - Tag: validateISO3166_1
  public static func validateISO3166_1(code countryCode: String) -> Bool {
    return countryCodes.contains(countryCode.uppercased())
  }
  
  /**
   Returns a boolean indicating whether a given string is a valid subdivision code.
   
   For more information on ISO 3166-2 subdivision codes see [this Wikipedia article.](https://en.wikipedia.org/wiki/ISO_3166-2)
   
   - parameter code: A string representing an ISO 3166-2 subdivision code, e.g. "GB-ENG" for England or "GB-WLS" for Wales.
   - returns: `Bool` Whether or not the given subdivision code is a valid case of the [Veximoji.ISO3166_2](x-source-tag://ISO3166_2) enum.
   
   # Example #
   ```
   let englandCode = "gb-eng" // supports uppercase, lowercase, and mixed-case strings
   
   if Veximoji.validateISO3166_2(code: englandCode)  {
    print("That subdivision code is valid")
   } else {
    print("That subdivision code is invalid")
   }
   ```
   */
  /// - Tag: validateISO3166_2
  public static func validateISO3166_2(code subdivisionCode: String) -> Bool {
    return subdivisionCodes.contains(subdivisionCode.uppercased())
  }
  
  /**
   Returns a boolean indicating whether a given string is a valid ISO 3166-1 exceptionally reserved code.
   
   For more information on ISO 3166-1 exceptional reservations see [this Wikipedia article.](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Exceptional_reservations)
   
   - parameter code: A string representing an ISO 3166-1 exceptionally reserved code, e.g. "EU" for the European Union or "UN" for the United Nations.
   - returns: `Bool` Whether or not the given exceptionally reserved code is a valid case of the [Veximoji.ExceptionalReservations](x-source-tag://ExceptionalReservations) enum.
   
   # Example #
   ```
   let euCode = "eu" // supports uppercase, lowercase, and mixed-case strings
   
   if Veximoji.validateExceptionalReservation(code: euCode)  {
    print("That reserved code is valid")
   } else {
    print("That reserved code is invalid")
   }
   ```
   */
  /// - Tag: validateExceptionalReservation
  public static func validateExceptionalReservation(code internationalCode: String) -> Bool {
    return internationalCodes.contains(internationalCode.uppercased())
  }
  
  // MARK: - Flag Emoji Methods
  
  /**
   Returns the corresponding emoji flag of a valid and legal ISO 3166 alpha-2 country code.
   
   The given country code is deemed valid if it is a member of [Core Foundation's](https://developer.apple.com/documentation/corefoundation) [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) collection. This condition is only met if [Veximoji.validateISO3166_1](x-source-tag://validateISO3166_1) returns `true` for the given country code.
   
   - parameter code: A string representing a country code, e.g. "US" for United States of America or "DO" for Dominican Republic.
   - returns: `String?` Either a string representing the emoji flag of the given ISO 3166 country code or `nil` if an invalid or illegal country code is provided.
   
   # Example #
   ```
   if let emojiFlag = Veximoji.country(code: "DO")  {
    print("The Dominican Flag: \(emojiFlag)")
   }
   ```
   */
  public static func country(code countryCode: String?) -> String? {
    if let countryCode = countryCode {
      let category = FlagCategory(type: .country, validator: Veximoji.validateISO3166_1(code:), scalars: nil)
      return getFlag(category: category, query: countryCode)
    } else {
      return nil
    }
  }
  
  /**
   Returns the corresponding emoji flag of a valid and legal ISO 3166-2 subdivision code.
   
   The given subdivision code is deemed valid if it is a member of the [Veximoji.ISO3166_2](x-source-tag://ISO3166_2) enum. This condition is only met if [Veximoji.validateISO3166_2](x-source-tag://validateISO3166_2) returns `true` for the given subdivision code.
   
   - parameter code: A string representing an ISO 3166-2 subdivision code, e.g. "GB-ENG" for England or "GB-WLS" for Wales.
   - returns: `String?` Either a string representing the emoji flag of the given subdivision code or `nil` if an invalid or illegal code is provided.
   
   # Example #
   ```
   if let walesFlag = Veximoji.subdivision(code: "GB-WLS")  {
    print("Baner Cymru: \(walesFlag)")
   }
   ```
   */
  public static func subdivision(code subdivisionCode: String?) -> String? {
    if let subdivisionCode = subdivisionCode {
      let category = FlagCategory(type: .subdivision, validator: Veximoji.validateISO3166_2(code:), scalars: Veximoji.iso3166_2Scalars)
      return getFlag(category: category, query: subdivisionCode)
    } else {
      return nil
    }
  }
  
  /**
   Returns the corresponding emoji flag of an exceptionally reserved ISO 3166-1 alpha-2 code.
   
   The provided exceptionally reserved code is deemed valid if it is a member of the [Veximoji.ExceptionalReservations](x-source-tag://ExceptionalReservations) enum. This condition is only met if [Veximoji.validateExceptionalReservation](x-source-tag://validateExceptionalReservation) returns `true` for the given exceptionally reserved code.
   
   - parameter code: A string representing an ISO 3166-1 exceptionally reserved code, e.g. "EU" for the European Union or "UN" for the United Nations.
   - returns: `String?` Either a string representing the emoji flag of the given exceptionally reserved code, code or `nil` if an invalid or illegal code is provided.
   
   # Example #
   ```
   if let euFlag = Veximoji.international(code: "EU")  {
    print("The European Union Flag: \(euFlag)")
   }
   ```
   */
  public static func international(code internationalCode: String?) -> String? {
    if let internationalCode = internationalCode {
      let category =  FlagCategory(type: .international, validator: Veximoji.validateExceptionalReservation(code:), scalars: Veximoji.exceptionalReservationScalars)
      
      return getFlag(category: category, query: internationalCode)
    } else {
      return nil
    }
  }
  
  /**
   Returns the corresponding emoji flag of a given cultural term associated with [Veximoji.CulturalTerms](x-source-tag://CulturalTerms).
   
   In this context, cultural term refers to an emoji flag that does not correspond to a country or region, but rather to a cultural reference, movement, or ideology. This method receives a cultural term and sequentially appends the corresponding scalars to a string and returns it.
   
   - parameter term: A valid case of [Veximoji.CulturalTerms](x-source-tag://CulturalTerms) (e.g. `.pride` for the rainbow or "pride" flag or `.pirate` for the pirate flag or "Jolly Roger")
   - returns: `String?` Either a string representing the emoji flag of the cultural term or `nil` if an invalid or illegal term is provided.
   
   # Example #
   ```
   if let pirateEmojiFlag = Veximoji.cultural(named: .pirate)  {
    print("Jolly Roger": \(pirateEmojiFlag)")
   }
   ```
   */
  public static func cultural(term: CulturalTerms?) -> String? {
    if let term = term {
      guard let scalars = culturalTermScalars[term] else { return nil }
      
      let category = FlagCategory(type: .cultural, validator: nil, scalars: [term.rawValue: scalars])
      return getFlag(category: category, query: term.rawValue)
    } else {
      return nil
    }
  }
  
}
