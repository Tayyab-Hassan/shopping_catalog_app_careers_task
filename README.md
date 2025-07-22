# Shopping Catalog App

A Flutter-based shopping catalog application built as part of the **Track 3: Flutter Developer Task**.  
This app fetches product data from a public API and provides a smooth shopping experience with features like search, favorites, filtering, and cart management.

##  Features

- > Fetch product list from [FakeStoreAPI](https://fakestoreapi.com/)
- > Display products in a responsive **GridView**
- > Add/Remove products from **Favorites** (locally persisted)
- > Add/Remove products from **Cart**
- > **Search** products by name
- > **Category filter** to filter products by type
- > Clean UI with organized code structure (Models, Screens, Widgets)
- > State management using `setState`

##  Folder Structure

lib/
├── models/ # All Data models
├── Providers/ # All Provider file for Statemanagement
├── screens/ # UI screens
├── Services/ # All Services file are here like (local storge Services,api services etc)
├── widgets/ # All Reusable and Custom widgets
└── main.dart # App entry point