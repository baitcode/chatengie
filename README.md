# chatengie

iOS chat client written in February 2016 as a test task for Engie.

## What it does

- Log in with a user name.
- Add a friend to start a chat, and see the list of chats.
- Send messages and receive new ones from the chat API (`getMessages`, `sendMessage`).

## Structure

| File | Role |
| --- | --- |
| `EngieApiClient.swift` | HTTP client for the chat API, behind the `IChatApiClient` protocol |
| `MessageLoader.swift` | Fetches new messages per user, tracking the last seen message id |
| `ChatStorage.swift` | In-memory storage of chats and messages |
| `Actions.swift`, `Notifications.swift` | App actions and the notifications that update the views |
| `*Controller.swift` | Welcome, chat list and chat screens |

## Build

```sh
pod install
open chatengie.xcworkspace
```

Dependencies: Alamofire 3.2, PromiseKit 3.0 and SwiftSpinner 0.8.

## Status

Written in Swift 2 for iOS 8, so it will not compile with a current Xcode
without migration.
