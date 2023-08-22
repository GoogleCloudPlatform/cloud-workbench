# Installation Steps

## Clone the repo

```sh
git clone git@github.com:gcp-solutions/cloud-workbench.git && cd cloud-workbench
```

If you are running this setup locally, run the following command to authenticate: 
```sh
gcloud auth login
```

Set the project ID for this deployment:
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

gcloud firestore databases create --location=$REGION

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

Generate Firebase options file:
```sh
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin:"
```

```sh
( cd ui && flutterfire configure -p ${PROJECT_ID} -y )
```

If you see an *Unexpected end of input* exception when running the above command, delete some
Firebase projects, or switch to a user with visibility of fewer projects.

## SetUI Values
### Enable Google Auth Provider

This is a manual step through the Firebase UI.

1. Go to the [Firebase console](https://console.firebase.google.com) and select your project
2. Click on  **Build -> Authentication** in the left nav bar
3. Click **Get started**
4. Click **Setup sign-in method**
5. Click **Google**
6. Click **Enable**
7. Set the Project public-facing name to **Developer Workbench**
8. Enter a **Support email** for the project
9. Click **Save**
10. View the Google configuration, click on the new **Google** entry
11. Click on **Web SDK configuration**
12. Copy the **Web Client ID** Value
13. Copy the file `ui/assets/env.sample` to create an `env` file in the same directory
14. Set that value in the file `ui/assets/env` as `CLIENT_ID='value'`, using the **Web Client ID** value

### Retrieve your Firebase config object

This is a manual step through the Firebase UI.

1. Go to [Project settings](https://console.firebase.google.com/project/_/settings/general/) in the Firebase console
   and select your project
1. In the **Your apps** section of the page, find the **cloudprovision** app
1. Select **Config** radio button in the Firebase SDK snippet pane
1. Copy the config object snippet. It should look like the following example (that has sensitive fields redacted):

```
const firebaseConfig = {
  apiKey: "<REDACTED>",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id.,
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "<REDACTED>",
  appId: "1:<REDACTED>:web:<REDCATED>"
};
```

Run the following command to create a template, and populate the template with the values you retrieved
from the Firebase UI:

```
cat << EOF > firebase-env-file.yaml
FIREBASE_CONFIG: '{ apiKey: "", authDomain: "", projectId: "", storageBucket: "", messagingSenderId: "", appId: "" }'
EOF
```

### Deploy

Run the following command to build a new image and deploy it to Cloud Run:

```sh
gcloud run deploy developer-workbench \
  --source . \
  --region $REGION \
  --allow-unauthenticated \
  --quiet \
  --env-vars-file firebase-env-file.yaml
```

Or, if you are using a prebuilt image:

```sh
gcloud run deploy developer-workbench \
  --image ${REGION}-docker.pkg.dev/${PROJECT_ID}/cloud-run-source-deploy/developer-workbench:latest \
  --region $REGION \
  --allow-unauthenticated \
  --quiet \
  --env-vars-file firebase-env-file.yaml
```

### Authorized domains configuration

Run the following command to print the URL for the settings page.

```sh
printf "\nhttps://console.firebase.google.com/u/0/project/$PROJECT_ID/authentication/settings\n"
```

Add your Cloud Run `developer-workbench` service domain (e.g. `developer-workbench-2lltdgq-ue.a.run.app`) to `Authorized Domains`.

### OAuth 2.0 Client - Authorized JavaScript origins configuration

Add the same Cloud Run `developer-workbench` service domain to `OAuth 2.0 Client IDs / Client ID for Web application / Authorized JavaScript origins`:

https://console.cloud.google.com/apis/credentials

You should now be able to log in to the service using the same Cloud Run service URL.

### User settings

Complete the configuration by following the [system settings steps](system_settings.md).

[Home](../README.md)
