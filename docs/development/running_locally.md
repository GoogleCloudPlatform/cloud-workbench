
Complete installation steps in [installation.md](../getting_started/installation.md)

## Front End

For VSCode your `launch.json` file should look similar to this:

```json
        {
            "name": "ui",
            "cwd": "ui",
            "request": "launch",
            "type": "dart",
            "args": [
              "--web-port=5000"
            ]
        }
```

To start the front end from the command line execute the following:

```bash
cd ui

flutter run lib/main.dart \
    -d chrome \
    --web-port=5000
```

For command above, add 'localhost:5000' to Authorized JavaScript origins under OAuth 2.0 Client in Cloud Console [APIs & Services, Credentials](https://console.cloud.google.com/apis/credentials).

[Home](../README.md)

# Deprecated

## Start backend service

Configure catalog repositories location:
```bash
vim server/config/env
```

Set FIREBASE_CONFIG environment variable before starting the backend service.
You can get the values in Firebase Console for your Cloud Workbench web application configuration.

```bash
export FIREBASE_CONFIG={ apiKey: "AIzaSyAnnnn", appId: "1:850000000:web:499f000000c", messagingSenderId: "850000", projectId: "cloud-workbench-1000-2000", authDomain: "cloud-workbench-1000-2000.firebaseapp.com", storageBucket: "cloud-workbench-1000-2000.appspot.com"}
```

Start backend service:
```bash
cd server
dart run lib/server.dart
```

## Front End

If you're debugging in the IDE make sure your debug profile is adding the following arguments

```sh
--dart-define=CLOUD_PROVISION_API_URL=localhost:8080
```

for VSCode your `launch.json` file should look similar to this:

```json
        {
            "name": "ui",
            "cwd": "ui",
            "request": "launch",
            "type": "dart",
            "args": ["--dart-define=CLOUD_PROVISION_API_URL=localhost:8080"]
        },
```

To start the front end from the command line execute the following:

```bash
cd ui

flutter run lib/main.dart \
    -d chrome \
    --web-port=5000 \
    --dart-define=CLOUD_PROVISION_API_URL=localhost:8080
```

For command above, add 'localhost:5000' to Authorized JavaScript origins under OAuth 2.0 Client in Cloud Console [APIs & Services, Credentials](https://console.cloud.google.com/apis/credentials). 

[Home](../README.md)
