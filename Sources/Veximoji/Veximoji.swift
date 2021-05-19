import Foundation

public struct Veximoji {
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
   Contains Unicode scalars for each case of the [Veximoji.culturalTermScalars](x-source-tag://culturalTermScalars) enum. Each scalar is a `UInt32` value that when sequentially appended to a string's `unicodeScalars` property composes the corresponding emoji flag.
   */
  /// - Tag: culturalTermScalars
  public static let culturalTermScalars: [CulturalTerms: [UInt32]] = [
    .pride: [UInt32(127987), UInt32(65039), UInt32(8205), UInt32(127752)],
    .trans: [UInt32(127987), UInt32(65039), UInt32(8205), UInt32(9895), UInt32(65039)],
    .pirate: [UInt32(127988), UInt32(8205), UInt32(9760), UInt32(65039)],
    .white: [UInt32(127987), UInt32(65039)],
    .black: [UInt32(127988)],
    .crossed: [UInt32(127884)],
    .triangular: [UInt32(128681)],
    .racing: [UInt32(127937)],
  ]
  
  // MARK: - Helpers
  
  /**
   Returns a boolean indicating whether a given string is a valid ISO 3611 Alpha-2 country code.
   
   For more information on ISO 3611-1 country codes visit [this Wikipedia article.](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)
   
   For more information on supported country codes visit the [CFLocaleCopyISOCountryCodes](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) page in the Apple Developer Documentation.
   
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
  public static func validateISO3166_1(code countryCode: String) -> Bool {
    let codes = CFLocaleCopyISOCountryCodes() as! Array<String>
    return codes.contains(countryCode.uppercased())
  }
  
//  public static func validateISO3166_2
  
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