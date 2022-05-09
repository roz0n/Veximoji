<div align="center" width="100%">
  <img src="./Logotype.png">
</div>

<p align="center" width="100%">
  Swiftly convert country codes and other unique strings to emoji flags
</p>

<div align="center" width="100%">

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Froz0n%2FVeximoji%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/roz0n/Veximoji)
&nbsp; [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Froz0n%2FVeximoji%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/roz0n/Veximoji)

</div>

# Usage

```swift
let usa = "us".flag() // "🇺🇸"
let england = "gb-eng".flag() // "🏴󠁧󠁢󠁥󠁮󠁧󠁿"
let un = "un".flag() // "🇺🇳"
let chequered = "chequered".flag() // "🏁"
```

## Demo

Check out the [**`Veximoji-Example`**](https://github.com/roz0n/Veximoji-Example) iOS app.

## Installation

Package installation follows traditional Swift conventions.

### Swift Package Manager

#### Manual Installation

- Add **`package(url: "https://github.com/roz0n/Veximoji.git", from: "2.0.0")`** to your application's **`Package.swift`** file.

#### Via Xcode

1. Open your project within Xcode and select **`File > Swift Packages > Add Package Dependency`** from the status bar menu.
2. Paste the HTTPS Github link: **`https://github.com/roz0n/Veximoji.git`** and click **`Next`**.
3. You'll be asked to define package options. **`Up to Next Major`** is a safe default which accepts any version up to the next major release, click **`Next`** to proceed.

Once the package finishes downloading, should now see it listed in the Project Navigator on the left-hand pane. Likewise, feel free to select the project file, and **`Veximoji`** should be listed under the **`Swift Packages`** tab. Xcode will also automatically add it to your main project target under the **"Frameworks, Libraries, and Embedded Content"** header.

### CocoaPods

CocoaPods support is in the works.

# API

The **`Veximoji`** API is very concise and well-documented. It organizes emoji flags into four distinct categories:

| Category        | Definition                                                | Example                 |
| :-------------- | :-------------------------------------------------------- | :---------------------- |
| `country`       | flags for countries with an ISO 3611-1 alpha-2 code       | `JP`                    |
| `subdivision`   | flags for subdivisions with an ISO 3611-2 code            | `GB-ENG`                |
| `international` | flags for exceptionally reserved ISO 3166-1 alpha-2 codes | `EU` or `UN`            |
| `unique`        | flags not related to individual countries or subdivisions | `.pirate` or `"pirate"` |

## Categories

Each of the above categories are available in array-form via publicly exposed short-hand variables:

### `EmojiFlagCountryCodes: [String]`

- Computes and returns all supported [ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) country codes.

### `EmojiFlagSubdivisionCodes: [String]`

- Computes and returns all supported [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) subdivision codes.

### `EmojiFlagInternationalCodes: [String]`

- Computes and returns all supported exceptionally reserved [ISO 3166-1](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes) codes.

## Helpers

### `String.flag(term:) -> String?`

- Converts any string to its emoji flag counterpart if the string exists within a `FlagCategory`.

### `country(code:) -> String?`

- Used to render a country's emoji flag by its ISO 3611-1 alpha-2 code

### `subdivision(code:) -> String?`

- Used to render a given subdivision’s emoji flag by its ISO 3611-2 code

##### Supported Codes

| Code     | Flag |
| :------- | :--- |
| `GB-ENG` | 🏴󠁧󠁢󠁥󠁮󠁧󠁿   |
| `GB-SCT` | 🏴󠁧󠁢󠁳󠁣󠁴󠁿   |
| `GB-WLS` | 🏴󠁧󠁢󠁷󠁬󠁳󠁿   |

### `international(code:) -> String?`

- Used to render the flag of an exceptionally reserved ISO 3166-1 alpha-2 code

##### Supported Codes

| Code | Flag |
| :--- | :--- |
| `EU` | 🇪🇺   |
| `UN` | 🇺🇳   |

### `unique(term:) -> String?`

- Refers to an emoji flag that do not correspond to a country, region, or government entity. For example, **`.pride`** or `"pride"` refers to the rainbow or _pride_ flag.

##### Supported Cases

| Case         | Raw value     | Flag |
| :----------- | :------------ | :--- |
| `.pride`     | `“pride”`     | 🏳️‍🌈   |
| `.trans`     | `“trans”`     | 🏳️‍⚧️   |
| `.pirate`    | `“pirate”`    | 🏴‍☠️   |
| `.white`     | `“white”`     | 🏳️   |
| `.red`       | `“red”`       | 🚩   |
| `.black`     | `“black”`     | 🏴   |
| `.crossed`   | `“crossed”`   | 🎌   |
| `.chequered` | `“chequered”` | 🏁   |

## Validators

In the event you would like to validate any of the above codes or terms manually for whatever reason, **`Veximoji`** exposes its validation methods for your convenience.

### `validateISO3166_1(code:) -> Bool`

- Returns a boolean indicating whether a given string is a supported ISO 3611 alpha-2 country code by checking whether or not it is contained within the **`CFLocaleCopyISOCountryCodes`** collection
- For more information on supported country codes visit the [**CFLocaleCopyISOCountryCodes**](https://developer.apple.com/documentation/corefoundation/1543372-cflocalecopyisocountrycodes) page of the Apple Developer Documentation

### `validateISO3166_2(code:) -> Bool`

- Returns a boolean indicating whether a given string is a valid ISO 3611-2 subdivision code
- Currently, only Great Britain’s subdivision codes are supported as they are the only subdivisions with iOS-supported emoji flags

### `validateExceptionalReservation(code:) -> Bool`

- Returns a boolean indicating whether a given string is a valid ISO 3166-1 exceptionally reserved code.
- Currently, only `"EU"` and `"UN"` exceptionally reserved codes are supported as they are the only codes with iOS-supported emoji flags

## Support

Email me at: [arnold@rozon.org](mailto:arnold@rozon.org)

## License

MIT
