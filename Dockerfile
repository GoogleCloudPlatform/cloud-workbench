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

FROM ubuntu:20.04 as ui-build

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
COPY --chown=flutter:flutter shared ./shared
COPY --chown=flutter:flutter ui ./ui
RUN cd ui && flutter build web

# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS api-build

# Resolve app dependencies.
WORKDIR /app
COPY shared ./shared
COPY server/pubspec.* ./server/

RUN cd server && dart pub get

# Copy app source code and AOT compile it.
COPY server ./server
# Ensure packages are still up-to-date if anything has changed
RUN cd server && dart pub get --offline
RUN cd server && dart compile exe lib/server.dart -o ./server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch

COPY --from=api-build /runtime/ /
COPY --from=api-build /app/server/config/env /app/bin/config/env
COPY --from=api-build /app/server/server /app/bin/

COPY --from=ui-build /home/flutter/app/ui/build/web /app/bin/public
COPY --from=ui-build /home/flutter/app/ui/assets/images /app/bin/public/assets/images

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]