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
