### Cloud Provision UI

Set the values in cloudprovisionui/assets/env file.
```
# Client ID from Firebase Web App config
CLIENT_ID=''
```

To run application locally:
```
flutter run lib/main.dart \
    -d chrome \
    --web-port=5000 \
    --dart-define=CLOUD_PROVISION_API_URL=localhost:8080
```

Build and Deploy application:

```bash
gcloud run deploy cloudprovisionui \
  --source . \
  --region us-east1 \
  --allow-unauthenticated
```
