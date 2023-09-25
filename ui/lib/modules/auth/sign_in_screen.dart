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

import 'package:cloudprovision/modules/auth/repositories/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Developer Workbench',
          style: GoogleFonts.openSans(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(
              "Welcome to Google Cloud Developer Workbench",
              style: GoogleFonts.openSans(
                fontSize: 32,
                color: Color(0xFF1b3a57),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Divider()),
            SelectableText(
              "Accelerating development on Google Cloud",
              style: GoogleFonts.openSans(
                fontSize: 18,
                color: Color(0xFF1b3a57),
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign In",
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    color: Color(0xFF1b3a57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                IconButton(
                  onPressed: () {
                    _authenticateWithGoogle(context);
                  },
                  icon: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                    height: 30,
                    width: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _authenticateWithGoogle(context) {
    final authRepo = ref.read(authRepositoryProvider);
    authRepo.signInWithGoogle();
  }
}
