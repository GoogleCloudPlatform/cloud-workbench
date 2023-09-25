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

import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenValidationHandler {
  Middleware tokenValidationHandler({Map<String, String>? headers}) {
    return (Handler handler) {
      return (Request request) async {
        if (request.url.path != "v1/env" && !_isValidToken(request)) {
          return Response.forbidden(
            JsonEncoder.withIndent(' ').convert({"msg": "Forbidden"}),
          );
        }

        return await handler(request);
      };
    };
  }

  bool _isValidToken(Request request) {
    // if (request.method == "OPTIONS") {
    //   return true;
    // }

    if (request.headers[HttpHeaders.authorizationHeader] != null) {
      try {
        String? authorization =
            request.headers[HttpHeaders.authorizationHeader];
        List<String> tokens = authorization!.split(" ");
        if (tokens.length != 2 || tokens[0] != "Bearer") {
          return false;
        }

        var token = tokens[1];

        if (JwtDecoder.isExpired(token)) {
          print("Expired token");
          return false;
        }

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // if (decodedToken["iss"] != "accounts.google.com") {
        //   print("Invalid iss - ${decodedToken["iss"]}");
        //   return false;
        // }
      } catch (e) {
        print(e);
        return false;
      }

      return true;
    }
    print("401 Unauthorized");
    return false;
  }
}
