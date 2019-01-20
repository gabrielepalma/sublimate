# sublimate
Sublimate: Ridiculously fast full stack Swift prototyping with Vapor and Sourcery

# Quick start:

- install Sourcery, Vapor and CocoaPods
  ```sh 
  brew install cocoapods
  brew install sourcery
  brew install vapor/tap/vapor
  ```
- clone Sublimate repo
  ```sh 
  $ git clone https://github.com/gabrielepalma/sublimate.git
  ```
- edit the file Demo.swift in Sourcery/Models: 
  - add new frost models as you see fit. 
  - if implements FrozenModel, it will be public and won't require any authentication
  - if implements OwnedFrozenModel, it will be private, matched to the user and require authentication
  - the primary keys will be added automatically.
  - only Int, Double and String field types are currently supported
- run Sourcery: from the repository root run
    ```sh 
  $ sourcery
  ```
- create the Vapor project: from SublimateVapor folder run
    ```sh 
  $ vapor xcode
  ```
- open the Vapor project and run it
- download CocoaPods dependencies: from SublimateClient folder run
    ```sh 
  $ pod install
  ```
- open the Client workspace and run it on simulator

# Features
The project provides:

On server: 
- fluent models for Vapor generated from the frost models provided
- appropriate GET, POST and DELETE routes for CRUD operation on models
- middlewares for the routes requiring authentication 
- authentication logic based on Refresh/Access dichotomy and JWT tokens.

On client:
- network clients and related DTOs based on PromiseKit
- an offline-first synchronization framework (SublimateSync) based on RxSwift and Realm.
- a mock UI (SublimateUI) to be used as a demo/test application
- an authentication client, manager and view controller, including automatic refresh of the access token

The resulting mock UI is ready to run, demonstrating authentication, synchronization and (randomized) CRUD operations.

<img src="https://raw.githubusercontent.com/gabrielepalma/sublimate/master/Sublimate.jpg" />

# Coming next

- customizable User Profile
- support for image upload (via multipart POST requests) and download (with cache and arbitrary thumbnail resizing)


