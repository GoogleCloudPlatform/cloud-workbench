# Installation Steps

## Clone the repo

```sh
git clone git@github.com:gcp-solutions/cloud-workbench.git && cd cloud-workbench
```

If you are running this setup locally, run command to authenticate: 
```sh
gcloud auth login
```

Set project id for this deployment:
```sh
gcloud config set project PROJECT_ID
```


### Store base project vars

```sh
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID \
--format='value(projectNumber)')
export REGION=us-east1
```

## Configure Cloud Services

### Enable APIs

```sh
gcloud services enable \
 run.googleapis.com \
 container.googleapis.com \
 artifactregistry.googleapis.com \
 cloudbuild.googleapis.com \
 firebase.googleapis.com \
 identitytoolkit.googleapis.com \
 people.googleapis.com
```

```sh
gcloud services enable \
 secretmanager.googleapis.com \
 containeranalysis.googleapis.com \
 recommender.googleapis.com \
 containerscanning.googleapis.com \
 firestore.googleapis.com
```

Enable Firebase for the project:
```sh
curl -sL https://firebase.tools | upgrade=true bash

firebase login --no-localhost

firebase --non-interactive projects:addfirebase $PROJECT_ID
```

Create Firestore database:
```sh
gcloud app create --region=$REGION

gcloud firestore databases create --region=$REGION

sed "s/PROJECT_ID/$PROJECT_ID/g" firebaserc.tmpl > .firebaserc

firebase deploy
```


Grant permissions to service accounts:
```
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
    --role=roles/run.developer

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com    \
    --role=roles/editor

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-cloudbuild.iam.gserviceaccount.com    \
    --role=roles/secretmanager.admin

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com    \
    --role=roles/secretmanager.admin

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
    --role=roles/iam.serviceAccountUser
```

Create Artifact Registry:
```
gcloud artifacts repositories create cp-repo --repository-format=docker --location=us-central1
```

Generate firebase options file:
```sh
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin:"
```

```sh
( cd ui/cloudprovisionui && flutterfire configure -p ${PROJECT_ID} -y )
```

## SetUI Values
### Enable Google Auth Provider
This is manual step through the UI

1. Go to firebase console https://console.firebase.google.com and select your project
2. Click on  **Build -> Authentication** in the left nav bar
3. Click Get started
4. Click **Setup sign-in method**
5. Click **Google**
6. Click **Enable**
7. Set the Project public-facing name to **Developer Workbench**
8. Select a **Project support email**
9. Click Save
10. View the Google configuration, Click on the new **Google** entry
11. Click on **Web SDK configuration**
12. Copy the Web Client ID Value
13. Create 'env' file using env.sample. Set that value in ui/cloudprovisionui/assets/env file as CLIENT_ID='value'

 

### Deploy

```sh
gcloud run deploy developer-workbench \
  --source . \
  --region $REGION \
  --allow-unauthenticated \
  --quiet
```


### Authorized domains configuration

Run the command to print URL for settings page.
Add developer-workbench service domain(ex. developer-workbench-2lltdgq-ue.a.run.app) to Authorized domains under Authentication/Settings:

```sh
printf "\nhttps://console.firebase.google.com/u/0/project/$PROJECT_ID/authentication/settings\n"
```

### OAuth 2.0 Client - Authorized JavaScript origins configuration

Add Cloud Run URL for deployed service to OAuth 2.0 Client IDs / Client ID for Web application / Authorized JavaScript origins:

https://console.cloud.google.com/apis/credentials

### User settings

Complete the configuration by following steps under usermanual/README.md.