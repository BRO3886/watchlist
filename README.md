
# Watchlist

An app to store your movie watchlist. Yellow Class's take home task.


## Installation

- First clone the repo
- Run command to get packages
- Run command to generate `*.g.dart` files
- Run app
```bash
git clone https://github.com/BRO3886/watchlist
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Dependencies
* To run this app you need to have a firebase project. Create one first and add the `google-services.json` file to the required folder.

* List of Dependencies given below:

| Parameter | Description                       |
| :-------- | :-------------------------------- |
| `auto_route`| Routing |
| `bloc`| State Management |
| `firebase_auth`, `google_sign_in`| Google Sign in |
| `hive`| Database |
| `image_picker`| Getting images from gallery |
| `get_it`, `injectable`| Dependency Injection |

## Authors

- [@BRO3886](https://www.github.com/BRO3886)

![Screenshot from 2021-10-04 23-41-44](https://user-images.githubusercontent.com/39856034/135902913-42d425cf-d900-44e4-944d-81d9abe1234c.png)


