
This repository houses my **Rick and Morty** iOS application, serving as a personal pet project for training and enhancing my swift development skills.

## Functionality

The app consists of some screens/features, designed to provide a seamless user experience for exploring the Rick and Morty universe.

### 1. Episodes List
   **feature**: Presents a paginated list of all episodes, allowing users to easily browse and discover content.
   
### 2. Episodes Details
   **feature**: Contains detailed information about the selected episode, including the characters featured in the episode
   
### 3. Characters List
   **feature**: Presents a paginated list of all characters, allowing users to easily browse and discover content.
   
### 4. Character Details
   **feature**: Provides in-depth information about a selected character, including their picture and status (alive, dead, etc).
   
### 5. Random character detail view
    **feature**:The title screen features a button that displays a detail screen for a random character.

### 6. Random episode detail view
	**feature**:The title screen features a button that displays a detail screen for a random episode.


### Architecture & Design Patterns

* **SOLID Principles**: The application follows _SOLID_ principles (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion), leading to a more flexible and adaptable codebase.
* **MVVM Pattern**: The Model-View-ViewModel (_MVVM_) pattern is employed to structure the presentation layer, providing a clear separation between UI logic and business logic.

### Data Layer

* **Remote API Service**: 
The application receives data through http get requests [the Rick and Morty API](https://rickandmortyapi.com/) and receives json data files, which are subsequently translated into a data model.


### Presentation Layer (View)

Clean SwiftUI framework
