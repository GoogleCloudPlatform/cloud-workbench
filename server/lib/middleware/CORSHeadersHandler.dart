// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:shelf/src/middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

class CORSHeadersHandler {
  final overrideHeaders = {
    // TODO: Replace with Cloud Provision Frontend URLs during build & deployment
    ACCESS_CONTROL_ALLOW_HEADERS: '*',
    'Content-Type': 'application/json;charset=utf-8',
  };

  Middleware corsHeadersHandler() {
    return corsHeaders(
      headers: overrideHeaders,
    );
  }
}
