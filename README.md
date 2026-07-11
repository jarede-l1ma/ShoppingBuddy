### 🛒 ShoppingBuddy

ShoppingBuddy is a modern, lightweight iOS application designed to simplify your shopping experience. With an intuitive and highly performant interface, the app helps you create shopping lists, organize items by categories, track prices, and calculate your total purchase cost in real-time.

Built natively with SwiftUI and architected following modern iOS 17+ standards, the project relies exclusively on the new Observation Framework for state management, delivering a fast, robust, and clean codebase without relying on legacy reactive bindings.

### ✨ Key Features

Shopping List Creation: Easily create, edit, and manage multiple items in your shopping list.
Price Calculation: Add quantities and unit prices to instantly track your cart's total value in real-time.
Smart Categorization: Organize your products into visually distinct sections (e.g., Dairy, Fruits, Beverages, Cleaning, etc.).
Background Persistence: Your data is safely stored locally on your device in JSON format, with a highly optimized non-blocking background save process (I/O Debounce).
Interactive UI: Fluid animations, native swipe actions for checking/deleting items, and easy collapsible sections.

### 🛠 Technologies & Architecture
Language: Swift 6
UI Framework: SwiftUI
Architecture: MVVM (Model-View-ViewModel)
State Management: Observation Framework (@Observable) — 100% free of Combine/ObservableObject!
Data Persistence: FileManager (JSON) with Background Task.detached & Debounce mechanism for UI performance.
Concurrency: Swift Concurrency (async/await and Task).
Dependency Management: Swift Package Manager
### 🚀 Getting Started

Prerequisites
Xcode 15 or later (Recommended: Xcode 16+)
iOS 17.0 or later
Installation Steps
Clone the repository to your local machine:
bash

git clone https://github.com/jarede-l1ma/ShoppingBuddy.git
Open the project in Xcode:
bash

cd ShoppingBuddy
open ShoppingBuddy.xcodeproj
Select an iOS 17+ Simulator or your physical device.
Hit Cmd + R (Build and Run) to test the app!
⚙️ Configuration
No additional configuration is required for basic functionality. The application handles all file directory creations on the device automatically for storing your items.

### 🧪 Testing

The project includes automated Unit Tests and Integration Tests covering core functionalities (Model behaviors, ViewModels, and Persistence).

To run the tests, simply press Cmd + U inside Xcode.

### 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
