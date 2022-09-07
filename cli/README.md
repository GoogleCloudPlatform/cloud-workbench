## Cloud Provision Client

### Project Setup
Create new service account.

Grant permission to invoke Cloud Run:
```
gcloud run services add-iam-policy-binding cloud-provision-service \
--member='serviceAccount:cloud-provision@<project-id>.iam.gserviceaccount.com' \
--role='roles/run.invoker' \
--region=$REGION
```
Download account key json file and copy account key json into cp.json file.

Update tokenPath, cloudRunUrl and endpointPath in the cpClient.dart file.


### Download dependencies
```dart pub get```

### Run app
```dart run cpCLient.dart```
