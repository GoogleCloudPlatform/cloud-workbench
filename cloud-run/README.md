### Cloud Provision Server



## Running Service locally

Set up Application Default Credentials (ADC) by running command below.
This would allow service to call Google Cloud APIs.

Login credentials gcloud auth isn't enough, need ADC for the dart SDK

```bash
gcloud auth application-default login
```

Start Server
```sh
dart run lib/server.dart
```

## Configure Catalogs

Update catalogs in the `.env` file.

```
GCP_CATALOG_URL=https://raw.githubusercontent.com/gitrey/cp-templates/main/catalog.json
COMMUNITY_CATALOG_URL=https://raw.githubusercontent.com/gitrey/community-templates/main/catalog.json
PRIVATE_CATALOG_URL=
```




## Cloud Run Deployment

```sh
gcloud run deploy cloud-provision-server --source . \
  --region us-east1 \
  --allow-unauthenticated \
  --quiet
```