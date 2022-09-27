# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:20.04 as builder

RUN apt-get update && \
    apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r -g 1441 flutter && useradd --no-log-init -r -u 1441 -g flutter -m flutter

USER flutter:flutter

WORKDIR /home/flutter

ARG flutterVersion=stable

ADD https://api.github.com/repos/flutter/flutter/compare/${flutterVersion}...${flutterVersion} /dev/null

RUN git clone https://github.com/flutter/flutter.git -b ${flutterVersion} flutter-sdk

RUN flutter-sdk/bin/flutter precache

RUN flutter-sdk/bin/flutter config --no-analytics

RUN flutter-sdk/bin/flutter config --enable-web

ENV PATH="$PATH:/home/flutter/flutter-sdk/bin"
ENV PATH="$PATH:/home/flutter/flutter-sdk/bin/cache/dart-sdk/bin"

# Copy files to container and build
WORKDIR /home/flutter/app
COPY --chown=flutter:flutter . .
RUN cd cloudprovisionui && flutter build web

FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY --from=builder /home/flutter/app/package*.json ./


RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY --from=builder /home/flutter/app/server.js .
COPY --from=builder /home/flutter/app/cloudprovisionui/build/web ./public
COPY --from=builder /home/flutter/app/cloudprovisionui/assets/images ./public/assests/images

EXPOSE 8080
CMD [ "node", "server.js" ]