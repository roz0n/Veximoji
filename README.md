<div align="center" width="100%">
  <img src="./Logotype.png"> 
</div>

<br />

<div align="center" width="100%">
  <img href=“https://github.com/roz0n/Veximoji/actions/workflows/swift.yml” src="https://github.com/roz0n/Veximoji/actions/workflows/swift.yml/badge.svg?branch=main"> 
</div>

---

<p align="center" width="100%">
  Swiftly convert ISO country codes (incl. subdivisions and exceptional reservations) and cultural terms to all 269 iOS-supported emoji flags without hassle.  
</p>

<br />

<div align="center">
  <img src="./Diagram.png"> 
</div>

<br />

> **vex·il·lol·o·gy** (/ˌveksəˈläləjē/)
> *noun*: the study of flags.

From a developer's perspective, emojis are great. They're a vast collection of natively supported and recognizable icons with a wide variety of use cases. They enhance the visual appearance of labels and cells and do not require third-party dependencies.

Working with emojis in Swift is not as *swifty* as it could be, though. **`Veximoji`** aims to remedy that.

## Demo

Checkout the [**`Veximoji-Example`**](https://github.com/roz0n/Veximoji-Example) iOS app. 

## Installation

Package installation follows traditional conventions.

### Swift Package Manager

#### Manual Installation

Add **`package(url: "https://github.com/roz0n/Veximoji.git", from: "1.0.0")`**  to your application's **`Package.swift`** file.

#### Via Xcode

1. Open your project within Xcode and select **`File > Swift Packages > Add Package Dependency`** from the status bar menu.
2. Paste the HTTPS Github link: **`https://github.com/roz0n/Veximoji.git`** and click **`Next`**.
3. You'll be asked to define package options. **`Up to Next Major`**  is a safe default which accepts any version up to the next major release, click **`Next`** to proceed.

Once the package finishes downloading, should now see it listed in the Project Navigator on the left-hand pane. Likewise, feel free to select the project file, and **`Veximoji`** should be listed under the **`Swift Packages`**  tab. Xcode will also automatically add it to your main project target under the **"Frameworks, Libraries, and Embedded Content"** header.

### CocoaPods

CocoaPods support is not yet available, but it's on the [**roadmap**](#roadmap).

## API

The **`Veximoji`** API is very concise and well-documented. It supports four different emoji flag categories:

| Category | Definition | Example |
|:--|:--|:--|
| `country` | flags for countries with an ISO 3611-1 alpha-2 code |`JP`|
| `subdivision` | flags for subdivisions with an ISO 3611-2 code | `GB-ENG` |
| `international` | flags for exceptionally reserved ISO 3166-1 alpha-2 codes | `EU` or `UN` |
| `cultural` | flags not related to individual countries or subdivisions | `.pirate` |

Each emoji flag category has a method to obtain its flags.

### Flag Category Methods

#### `country(code:) -> String?`

- Used to render a country's emoji flag by its ISO 3611-1 alpha-2 code
- Returns a string containing the corresponding flag emoji if the given country code is valid, otherwise returns **`nil`**
- There is no need to manually check the validity of the given code as this method makes a call to **`validateISO3166_1(code:)`** already
- For more information on ISO 3611 country codes visit [this Wikipedia article.](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes)

##### Usage

```swift
if let flag = Veximoji.country(code: "DO")  {
  print("\(flag)") // "🇩🇴"
}
```

#### `subdivision(code:) -> String?`

- Used to render a given subdivision’s emoji flag by its ISO 3611-2 code
	- For clarity: England, Scotland, and Wales are considered *subdivisions* of Great Britain 
- Returns a string containing the corresponding flag emoji if the given subdivision code is valid, otherwise returns **`nil`**
- There is no need to manually check the validity of the given code as this method makes a call to **`validateISO3166_2(code:)`** already
- For more information on ISO 3611-2 codes visit [this Wikipedia article.](https://en.wikipedia.org/wiki/ISO_3166-2)

##### Supported Codes

| Code  | Flag |
|:--|:--|
| `GB-ENG`  | 🏴󠁧󠁢󠁥󠁮󠁧󠁿 |
| `GB-SCT`  | 🏴󠁧󠁢󠁳󠁣󠁴󠁿 |
| `GB-WLS`  | 🏴󠁧󠁢󠁷󠁬󠁳󠁿 |

##### Usage

```swift
if let flag = Veximoji.subdivision(code: "GB-SCT")  {
  print("\(flag)") // "🏴󠁧󠁢󠁳󠁣󠁴󠁿"
}
```

#### `international(code:) -> String?`

- Used to render the flag of an exceptionally reserved ISO 3166-1 alpha-2 code
- Returns a string containing the corresponding flag emoji if the given exceptionally reserved code is valid, otherwise returns **`nil`**
- There is no need to manually check the validity of the given code as this method makes a call to **`validateExceptionalReservation(code:)`** already
- For more information on exceptionally reserved codes visit [this Wikipedia article.](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Exceptional_reservations)

##### Supported Codes

| Code  | Flag |
|:--|:--|
| `EU`  | 🇪🇺 |
| `UN`  | 🇺🇳 |

##### Usage

```swift
if let flag = Veximoji.subdivision(code: "UN")  {
  print("\(flag)") // "🇺🇳"
}
```

#### `cultural(term:) -> String?`

In the context of **`Veximoji`**, *cultural term* refers to an emoji flag that does not correspond to a country or region, but rather to a cultural reference, movement, or ideology. For example, **`.pride`** refers to the "rainbow" or "pride" flag.

**`Veximoji`** contains the correct Unicode scalars needed to accurately render each emoji flag. Unlike the other flag category methods, it does not expect a string as input but instead references the publicly exposed **`CulturalTerms`** enum (which also supports raw values).

##### Supported Cases

| Case  | Raw value | Flag |
|:--|:--|:--|
| `.pride`  | “pride” | 🏳️‍🌈 |
| `.trans`  | “trans” | 🏳️‍⚧️ |
| `.pirate`  | “pirate” | 🏴‍☠️ |
| `.white`  | “white” | 🏳️ |
| `.black`  | “black” | 🏴 |
| `.crossed`  | “crossed” | 🎌 |
| `.triangular`  | “triangular” | 🚩|
| `.racing`  | “racing” | 🏁|

##### Usage

```swift
if let flag = Veximoji.cultural(term: .pride)  {
  print("\(flag)") // "🏳️‍🌈"
}
```

### Code Validation Methods

In the event you would like to validate any of the above codes or terms manually for whatever reason, **`Veximoji`** exposes its validation methods for your convenience.

#### `validateISO3166_1(code:) -> Bool`

- Returns a boolean indicating whether a given string is a supported ISO 3611 alpha-2 country code by checking whether or not it is contained within the **`CFLocaleCopyISOCountryCodes`** collection
- For more information on supported country codes visit the [**CFLocaleCopyISOCountryCodes**](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) page in the Apple Developer Documentation

##### Usage

```swift
let dominicanRepublicCode = "do" // supports uppercase, lowercase, and mixed-case strings

if Veximoji.validateISO3166_1(code: dominicanRepublicCode)  {
  print("That code is valid")
} else {
  print("That code is invalid")
}
```

#### `validateISO3166_2(code:) -> Bool`

- Returns a boolean indicating whether a given string is a valid ISO 3611-2 subdivision code
- Currently, **`Veximoji`** only supports Great Britain’s subdivision codes as they are the only subdivisions with iOS-supported emoji flags

##### Usage

```swift
let scotlandCode = "gb-sct" // supports uppercase, lowercase, and mixed-case strings

if Veximoji.validateISO3166_2(code: scotlandCode)  {
  print("That code is valid")
} else {
  print("That code is invalid")
}
```

#### `validateExceptionalReservation(code:) -> Bool`

- Returns a boolean indicating whether a given string is a valid ISO 3166-1 exceptionally reserved code.
- Currently, **`Veximoji`** only supports `EU` and `UN` exceptionally reserved codes as they are the only codes with iOS-supported emoji flags

##### Usage

```swift
let euCode = "eu" // supports uppercase, lowercase, and mixed-case strings

if Veximoji.validateExceptionalReservation(code: euCode)  {
  print("That code is valid")
} else {
  print("That code is invalid")
}
```

## Roadmap

- ~~Add support for exceptional reservations~~
- ~~Add support for subdivisions~~
- CocoaPods support
- Continually support new emoji flags as they are added to the Unicode standard and supported by Apple development platforms

## Support

Feel free to email me at [arnold@rozon.org](mailto:arnold@rozon.org)

## License

MIT