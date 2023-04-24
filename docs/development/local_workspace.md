## Start backend service

Configure catalog repositories location:
```bash
vim cloud-run/config/env
```

Start backend service:
```bash
cd cloud-run
dart run lib/server.dart
```

Start frontend application:

```bash
cd ui/cloudprovisionui

flutter run lib/main.dart \
    -d chrome \
    --web-port=5000 \
    --dart-define=CLOUD_PROVISION_API_URL=localhost:8080
```
For command above, add 'localhost:5000' to Authorized JavaScript origins under OAuth 2.0 Client in Cloud Console [APIs & Services, Credentials](https://console.cloud.google.com/apis/credentials). 


[Home](../README.md)