### Cloud Provision UI

Set the values in cloudprovisionui/assets/.env file.
```
# FirebaseOptions from Firebase console - web app config
PROJECT_ID=''
API_KEY=''
AUTH_DOMAIN=''
STORAGE_BUCKET=''
MESSAGING_SENDER_ID=''
APP_ID=''
MEASUREMENT_ID='

# Client ID from GCP Auth Credentials
CLIENT_ID=''

# Cloud Provision API Url
CLOUD_PROVISION_API_URL='cloud-provision-server-aaabbbccc-ue.a.run.app'
```

Build and Deploy application:

```bash
gcloud run deploy cloudprovisionui \
  --source . \
  --region us-east1 \
  --allow-unauthenticated
```
