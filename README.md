# DVT Weather App

DVT Weather is a weather application that provides users with the current weather at their location and a 5-day weather forecast. This app offers an intuitive user interface, beautiful visuals, and efficient data retrieval. It supports iOS 15.0 and above.

### Conventions, Architecture, and General Considerations

The app follows the Model-View-ViewModel (MVVM) architecture combined with Combine for reactive programming. This architecture promotes separation of concerns and enables a more modular, testable, and maintainable codebase. The app is designed with flexibility in mind, utilizing both UIKit and SwiftUI for different screens.

**File Structure:**
- **Views:** Contains the screens presented to the user, split into UIKit and SwiftUI subfolders.
- **ViewModels:** Houses the ViewModel logic, is responsible for managing data and interactions.
- **Models:** Defines the data structures used throughout the app.
- **Services:** Contains the WeatherRepository responsible for handling network calls.
- **Helpers:** Includes LocationManager for user location retrieval and CoreDataManager for data persistence.
- **Support Files:** Holds utility components like Reachability, Constants, UIComponents, extensions, and Toast for error handling.

### Third-Party Dependencies

The project adheres to the principle of minimizing third-party dependencies. However, a few have been used for cross-cutting concerns:
- **Reachability:** Monitors network connectivity for online/offline notifications.
- **Combine** Apple's framework for reactive programming.

### Building the Project

To build the project, follow these steps:

1. Clone the repository.
2. Open the Xcode project "DVTWeather.xcodeproj".
3. Make sure the deployment target is set to iOS 15.0.
4. Build and run the app on the simulator or a physical device.

### Additional Notes

**Flexibility with UIKit and SwiftUI:** Using both UIKit and SwiftUI demonstrates the ability to work with various UI frameworks, catering to different design needs.

**SOLID Principles:** The app adheres to SOLID principles to ensure robust and maintainable code:
- **Single Responsibility Principle (SRP):** Each class has a single responsibility, promoting modularity.
- **Open-Closed Principle (OCP):** The codebase is open for extension (new features) but closed for modification (existing features).
- **Liskov Substitution Principle (LSP):** Subtypes (subclasses) can be substituted for their base types (superclasses) without altering correctness.
- **Interface Segregation Principle (ISP):** Clients are not forced to depend on interfaces they don't use.
- **Dependency Inversion Principle (DIP):** High-level modules do not depend on low-level modules; both depend on abstractions.

### Conclusion

DVT Weather is a feature-rich weather forecast app that showcases best practices in iOS development, including architecture, design patterns, and adherence to SOLID principles. It demonstrates versatility in combining UIKit and SwiftUI while keeping third-party dependencies to a minimum. The MVVM architecture and Combine provide a solid foundation for a clean, testable, and scalable codebase.


