# sublimate
Sublimate: Ridiculously fast full stack Swift prototyping with Vapor and Sourcery

Quick start:

1 - Clone the repository
2 - Edit file Demo.swift in Sourcery/Models: Add new FrozenModel(s) as you see fit. We currently only support Int, Double and String field types. OwnedFrozenModel(s) will require authentication. Primary keys will be added automatically.
3 - Run sourcery in Sublimate root. No parameters are needed as sourcery.yml is provided.
4 - Open the project in SublimateVapor and Run it 
5 - Open the workspace in SublimateClient and Run it

The project provides:
On server: 

(i)   Fluent models for Vapor based on the models provided in Sourcery/Models/
(ii)  CRUD routes for Vapor models
(iii) Middlewares for authentication routes
(iv)  Authentication logic based on Refresh/Access JWT tokens.

On client:

(i)   Network client and related DTOs
(ii)  An offline-first synchronization framework (SublimateSync)
(iii) A mock UI (SublimateUI)
(iv)  Realm models extended to be used with both SublimateSync and SublimateUI
(v)   Authentication client, manager and view controller, including automatic refresh of the access token

The resulting mock UI should be ready to run, demonstrating authentication, synchronization and (randomized) CRUD operations.

All the above is designed to be partially thrown away. Network clients and DTOs can be used without the SublimateSync and the Realm models which are in turn designed to also be used without the mock UI. You can easily throw away what you don't need.

Current work in progress, soon to be available:

Customizable User Profile
Support for image upload (via multipart POST requests) and download (with cache and arbitrary thumbnail resizing)



