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
    case unique = "unique"
  }
  
  /**
   In this context, unique term refers to an emoji flag that does not correspond to a country or region, but rather to a unique reference, movement, or ideology.
   
   The unique term enum does not contain raw values. Its usage within `Veximoji` depends on the [Veximoji.uniqueTermScalars](x-source-tag://uniqueTermScalars) member which maps each enum case to an array of `UInt32` integers.
   */
  /// - Tag: UniqueTerms
  public enum UniqueTerms: String, CaseIterable {
    case pride = "pride"
    case trans = "trans"
    case pirate = "pirate"
    case white = "white"
    case red = "red"
    case black = "black"
    case crossed = "crossed"
    case chequered = "chequered"
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
   Contains Unicode scalars for each case of the [Veximoji.UniqueTerms](x-source-tag://UniqueTerms) enum. Each scalar is a `UInt32` value that when sequentially appended to a string's `unicodeScalars` property composes the corresponding emoji flag.
   
   Public access to this dictionary is restricted. To access the scalars of a particular emoji flag, use the `unicodeScalars` property of its string.
   */
  /// - Tag: uniqueTermScalars
  fileprivate static let uniqueTermScalars: [UniqueTerms: [UInt32]] = [
    .pride: [UInt32(127987), UInt32(65039), UInt32(8205), UInt32(127752)],
    .trans: [UInt32(127987), UInt32(65039), UInt32(8205), UInt32(9895), UInt32(65039)],
    .pirate: [UInt32(127988), UInt32(8205), UInt32(9760), UInt32(65039)],
    .white: [UInt32(127987), UInt32(65039)],
    .red: [UInt32(128681)],
    .black: [UInt32(127988)],
    .crossed: [UInt32(127884)],
    .chequered: [UInt32(127937)]
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
   
   For more information on exceptional reservation codes see [this Wikipedia article](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Exceptional_reservations).
   */
  /// - Tag: internationalCodes
  public static var internationalCodes: [String] {
    get {
      return ExceptionalReservations.allCases.map { $0.rawValue }
    }
  }
  
  /**
   Computes and returns raw values of all [Veximoji.UniqueTerms](x-source-tag://UniqueTerms) enum cases.
   */
  public static var uniqueTerms: [String] {
    get {
      return UniqueTerms.allCases.map { $0.rawValue }
    }
  }
  
  public static var uniqueScalars: [UniqueTerms: [UInt32]] {
    get {
      return uniqueTermScalars
    }
  }
  
  // MARK: -
  
  /// Used internally to create and return an emoji flag based on the `type` property of the given [Veximoji.FlagCategory](x-source-tag://FlagCategory).
  /// - Parameters:
  ///   - category: A class that inherits from [Veximoji.FlagCategory](x-source-tag://FlagCategory)
  ///   - query: A unique indentifier for a specific flag (e.g., a ISO 3166 alpha-2 country or reserved code, an ISO 3166-2 subdivision code, or a case of the [Veximoji.UniqueTerms](x-source-tag://UniqueTerms) enum).
  /// - Returns: `Bool` Either a string containing the corresponding flag emoji, or `nil`.
  /// - Tag: getFlag
  fileprivate static func getFlag<T: FlagCategory>(category: T, query: String) -> String? {
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
      case .unique:
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
   
   For more information on ISO 3166-1 country codes refer to this [Wikipedia page.](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
   
   For more information on supported country codes refer to the [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) page of the Apple Developer Documentation.
   
   - parameter code: A string representing an ISO 3166-1 alpha-2 country code (e.g. `"US"` for United States of America or `"DO"` for Dominican Republic)
   - returns: `Bool` Whether or not the given subdivision code is a member of Core Foundation's [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) collection.
   
   # Example #
   ```
   let code = "do"
   
   if Veximoji.validateISO3166_1(code: code)  {
    print("Code is valid")
   }
   ```
   */
  /// - Tag: validateISO3166_1
  public static func validateISO3166_1(code countryCode: String) -> Bool {
    return countryCodes.contains(countryCode.uppercased())
  }
  
  /**
   Returns a boolean indicating whether a given string is a valid subdivision code.
   
   For more information on ISO 3166-2 subdivision codes refer to this [Wikipedia article.](https://en.wikipedia.org/wiki/ISO_3166-2)
   
   - parameter code: A string representing an ISO 3166-2 subdivision code, e.g. `"GB-ENG"` for England or `"GB-WLS"` for Wales.
   - returns: `Bool` Whether or not the given subdivision code is a valid case of the [Veximoji.ISO3166_2](x-source-tag://ISO3166_2) enum.
   
   # Example #
   ```
   let code = "gb-eng"
   
   if Veximoji.validateISO3166_2(code: code)  {
    print("Code is valid")
   }
   ```
   */
  /// - Tag: validateISO3166_2
  public static func validateISO3166_2(code subdivisionCode: String) -> Bool {
    return subdivisionCodes.contains(subdivisionCode.uppercased())
  }
  
  /**
   Returns a boolean indicating whether a given string is a valid ISO 3166-1 exceptional reservation code.
   
   For more information on ISO 3166-1 exceptional reservations refer to this [Wikipedia article.](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Exceptional_reservations)
   
   - parameter code: A string representing an ISO 3166-1 exceptional reservation code, e.g. `"EU"` for the European Union or `"UN"` for the United Nations.
   - returns: `Bool` Whether or not the given exceptional reservation code is a valid case of the [Veximoji.ExceptionalReservations](x-source-tag://ExceptionalReservations) enum.
   
   # Example #
   ```
   let code = "eu"
   
   if Veximoji.validateExceptionalReservation(code: code)  {
    print("Code is valid")
   }
   ```
   */
  /// - Tag: validateExceptionalReservation
  public static func validateExceptionalReservation(code internationalCode: String) -> Bool {
    return internationalCodes.contains(internationalCode.uppercased())
  }
  
  // MARK: - Flag Emoji Methods
  
  /**
   Returns an optional string containing the emoji flag of a valid ISO 3166 alpha-2 country code.
   
   The given country code is deemed valid if it is a member of [Core Foundation's](https://developer.apple.com/documentation/corefoundation) [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) collection. This condition is only met if [Veximoji.validateISO3166_1](x-source-tag://validateISO3166_1) returns `true` for the given country code.
   
   - parameter code: A string representing a country code, e.g. `"US"` for United States of America or `"DO"` for Dominican Republic.
   - returns: `String?` Either a string representing the emoji flag of the given ISO 3166 country code or `nil` if an invalid or illegal country code is provided.
   
   # Example #
   ```
   if let code = Veximoji.country(code: "DO")  {
    print("\(code)")
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
   Returns an optional string containing the emoji flag of a valid ISO 3166-2 subdivision code.
   
   The given subdivision code is deemed valid if it is a member of the [Veximoji.ISO3166_2](x-source-tag://ISO3166_2) enum. This condition is only met if [Veximoji.validateISO3166_2](x-source-tag://validateISO3166_2) returns `true` for the given subdivision code.
   
   - parameter code: A string representing an ISO 3166-2 subdivision code, e.g. `"GB-ENG"` for England or `"GB-WLS"` for Wales.
   - returns: `String?` Either a string representing the emoji flag of the given subdivision code or `nil`.
   
   # Example #
   ```
   if let code = Veximoji.subdivision(code: "GB-WLS")  {
    print("\(code)")
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
   Returns an optional string containing the emoji flag of an ISO 3166-1 alpha-2 exceptional reservation code.
   
   The provided exceptional reservation code is deemed valid if it is a member of the [Veximoji.ExceptionalReservations](x-source-tag://ExceptionalReservations) enum. This condition is only met if [Veximoji.validateExceptionalReservation](x-source-tag://validateExceptionalReservation) returns `true` for the given exceptional reservation code.
   
   - parameter code: A string representing an ISO 3166-1 exceptional reservation code, e.g. `"EU"` for the European Union or `"UN"` for the United Nations.
   - returns: `String?` Either a string representing the emoji flag of the given exceptional reservation code or `nil`.
   
   # Example #
   ```
   if let code = Veximoji.international(code: "EU")  {
    print("\(code)")
   }
   ```
   */
  public static func international(code internationalCode: String?) -> String? {
    if let internationalCode = internationalCode {
      let category =  FlagCategory(type: .international,
                                   validator: Veximoji.validateExceptionalReservation(code:),
                                   scalars: Veximoji.exceptionalReservationScalars)
      return getFlag(category: category, query: internationalCode)
    } else {
      return nil
    }
  }
  
  /**
   Returns an optional string containing the emoji flag of a given unique term associated with [Veximoji.UniqueTerms](x-source-tag://UniqueTerms).
   
   In this context, unique term refers to an emoji flag that does not correspond to a country or region, but rather to a unique reference, movement, or ideology.
   
   - parameter term: A valid case of [Veximoji.UniqueTerms](x-source-tag://UniqueTerms) (e.g. `.pride` for the rainbow or "pride" flag or `.pirate` for the pirate flag otherwise known as "Jolly Roger")
   - returns: `String?` Either a string representing the emoji flag of the unique term or `nil`.
   
   # Example #
   ```
   if let code = Veximoji.unique(named: .pirate)  {
    print("\(code)")
   }
   ```
   */
  public static func unique(term: UniqueTerms?) -> String? {
    if let term = term {
      guard let scalars = uniqueTermScalars[term] else { return nil }
      
      let category = FlagCategory(type: .unique, validator: nil, scalars: [term.rawValue: scalars])
      return getFlag(category: category, query: term.rawValue)
    } else {
      return nil
    }
  }
  
  /**
   Converts a given string to an emoji flag if the string exists within a [Veximoji.FlagCategory](x-source-tag://FlagCategories) category.
   
   - parameter term: Any valid ISO 3166 alpha-2, ISO 3166-1 alpha-2, ISO 3166-2 code, or [Veximoji.UniqueTerms](x-source-tag://UniqueTerms) raw value.
   - returns: `String?` Either a string representing the emoji flag or `nil`.
   
   # Example #
   ```
   if let code = "UN".flag()  {
    print("\(code)")
   }
   ```
   */
  public static func flag(term: String) -> String? {
    return term.countryFlag() ?? term.subdivisionFlag() ?? term.internationalFlag() ?? term.uniqueFlag()
  }
  
}

extension String {
  /**
   Used internally by [String.flag](x-source-tag://flag) to obtain the emoji flag of a valid ISO 3166 alpha-2 country code.
   
   - returns: `String?` Either a string representing the emoji flag of the given ISO 3166 country code or `nil`.
   
   # Example #
   ```
   if let flag = "DO".countryFlag()  {
    print("\(flag)")
   }
   ```
   */
  fileprivate func countryFlag() -> String? {
    return Veximoji.country(code: self)
  }
  
  /**
   Used internally by [String.flag](x-source-tag://flag) to obtain the emoji flag of a valid ISO 3166-2 subdivision code.
   
   - returns: `String?` Either a string representing the emoji flag of the given subdivision code or `nil`.
   
   # Example #
   ```
   if let flag = "GB-WLS".subdivisionFlag()  {
    print("\(flag)")
   }
   ```
   */
  fileprivate func subdivisionFlag() -> String? {
    return Veximoji.subdivision(code: self)
  }
  
  /**
   Used internally by [String.flag](x-source-tag://flag) to obtain the emoji flag of an ISO 3166-1 alpha-2 exceptional reservation code.
      
   - returns: `String?` Either a string representing the emoji flag of the given exceptional reservation code or `nil`.
   
   # Example #
   ```
   if let flag = "EU".internationalFlag()  {
    print("\(flag)")
   }
   ```
   */
  fileprivate func internationalFlag() -> String? {
    return Veximoji.international(code: self)
  }
  
  /**
   Used internally by [String.flag](x-source-tag://flag) to obtain the emoji flag of a given unique term associated with [Veximoji.UniqueTerms](x-source-tag://UniqueTerms) raw values.
      
   - returns: `String?` Either a string representing the emoji flag of the unique term raw value or `nil`.
   
   # Example #
   ```
   if let code = "pirate".uniqueFlag()  {
    print("\(code)")
   }
   ```
   */
  fileprivate func uniqueFlag() -> String? {
    if let term = Veximoji.UniqueTerms.allCases.filter ({ $0.rawValue == self }).first {
      return Veximoji.unique(term: term)
    } else {
      return nil
    }
  }
  
  /**
   Converts the string to an emoji flag if the string exists within a [Veximoji.FlagCategory](x-source-tag://FlagCategories) category.
   
   - returns: `String?` Either a string representing the emoji flag or `nil`.
   
   # Example #
   ```
   if let code = "UN".flag()  {
    print("\(code)")
   }
   ```
   */
  /// - Tag: flag
  public func flag() -> String? {
    return Veximoji.flag(term: self)
  }
  
}
