# Ahaskade

This is the buyer mobile application for Ahaskade open ecosystem for
buyers who wish to buy from sellers willing to deliver goods to doorstep.

Ahaskade buyer app allows buyers to pick a grocery lists published by a
seller who can deliver to the city buyer is located.

This application needs network connectivity and uses APIs to create, retrieve
and do many other things. The hosted app would work as-is by consuming the
dev API. Please see the API documentation for API contracts.

# Resources
- [API Doc](docs/api.md)
- [Screens and Workflow](docs/screens_and_workflows.md)

# Getting Started
- This project is written using Flutter 1.12 and can be complied to work
in iOS and Android both.
- Clone the project
- Run `Pub get` to download the dependencies
- You'd need google maps API keys to access the user profile and order
information screens.
  - Copy `android/app/src/main/AndroidManifestSample.xml` as `android/app/src/main/AndroidManifest.xml`
  - Copy `ios/Runner/AppDelegateSample.swift` as `ios/Runner/AppDelegate.swift`
- Update the API key sections with your key
- Build the app
- Submit pull requests for your improvements

This project uses Google Firebase. However firebase JSON files are not shipped
with the repository. Please read the comments on `assets/config_loader.dart`
file for setting up the project with local configurations

# How can you contribute
well, this is a one of the apps of free app eco-system for sellers and buyers to meet. If you are an mobile developer you can contribute to this project by making a pull request.
Your contribution will help sellers to sell their products directly to consumers without going
through a middle man. This will also benefit consumers to deliver their essentials without
visiting a grocery store.
we've listed down the areas you can help us moving this project forward
## Refactoring code
well, we'd say this code needs refactoring and seriously incorporate some
engineering best practises. Please help us with that. Current state of the
source code is mealy meeting the MVP guidelines.
## Unit testing
This code does not have unit testing yet. please help up to have some testing
enabled so we can commit and merge more comfortably
## UI enhancements
We want this app to be functional in mostly low and medium-end devices as we
don't expect sellers or farmers to carry iPhones or shiny Galaxy phones.
However that doesn't mean we can't improve the UI to be effective without
using performance intensive rendering and animations.
## Fixing issues
Keep your eyes on Issues section in this repository. You can open BUG or ENHANCEMENT
tickets and in addition you can start fixing them as well

>So if you are ready to code, refer to Developer Guide to understand the core
>architecture of the app and API endpoints available for the app.


