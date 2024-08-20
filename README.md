# TeleChat: Real-Time Messaging & Video Calls

TeleChat is a real-time messaging and video calling application built with Flutter, Riverpod, Firebase services, Agora Video Call API, Giphy API and Heroku.

This project offers a seamless chat experience along with high-quality video calls.

## Features

- **Real-Time Messaging**: Exchange text messages and media (image, audio, video and gif) in real-time with other users.
- **Video Calls**: Engage in high-quality video calls powered by Agora.
- **Authentication**: Secure user authentication using Firebase Auth.
- **Cloud Firestore**: Store and sync user data in real-time with Cloud Firestore.
- **Firebase Storage**: Upload and retrieve media files like images and videos.
- **Remote Config**: Manage and update app configurations remotely without requiring an app update.
- **Server Deployment**: The video calling server is deployed on Heroku.

## Technologies Used

- **Flutter**: The UI toolkit used to build the natively compiled application for mobile from a single codebase.
- **Riverpod**: A robust state management solution for Flutter.
- **Firebase**: Integrated services for authentication, real-time database, and cloud storage.
  - **Firebase Auth**: Manages user authentication with email, Google, and other providers.
  - **Cloud Firestore**: Real-time NoSQL database for storing and syncing data.
  - **Firebase Storage**: Store and serve user-generated content like images and videos.
  - **Remote Config**: Allows dynamic updates to the app's configuration.
- **Agora**: API used for video calls, ensuring low-latency and high-quality video communication.
- **Giphy**: API for integrating GIFs into the chat, allowing users to send and receive animated GIFs.
- **Heroku**: Platform-as-a-service (PaaS) for deploying and managing the video call server.

## Getting Started

### Prerequisites

- **Flutter SDK**: Install from the official [Flutter website](https://flutter.dev/docs/get-started/install).
- **Firebase Account**: Sign up for a free account at [Firebase](https://firebase.google.com/).
- **Giphy Account**: Sign up at [Giphy](https://developers.giphy.com/) to obtain your API key.
- **Agora Account**: Register at [Agora](https://www.agora.io/en/) to get your App ID and Primary Certificate.
- **Heroku Account**: Sign up for Heroku at [Heroku](https://www.heroku.com/).

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/hizurk1/telechat.git
   cd telechat
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Set up Firebase:

- Create a new project on Firebase.
- Enable Authentication, Firestore, Storage and Remote Config.
- Download the `google-services.json` file and place it in the `android/app `directory.
- Checkout `lib/app/configs/remote_config.dart` for all needed config keys.

4. Set up Agora:

- Get your Agora `App ID` and `Primary Certificate` from the Agora Console.
- Add the App ID and Primary Certificate to your Firebase Remote Config.

5. Deploy the calling server to Heroku:
- Clone the calling server from [here](https://github.com/hizurk1/flutter-twitch-server).
- Follow the Heroku deployment guide to deploy the server.
- Update the server URL in Firebase Remote Config.
