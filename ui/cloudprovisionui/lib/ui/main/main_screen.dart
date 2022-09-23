import 'package:cloudprovision/blocs/auth/auth_bloc.dart';
import 'package:cloudprovision/ui/signin/sign_in.dart';
import 'package:cloudprovision/ui/templates/templates.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Provision'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                user.displayName != null
                    ? Text("${user.displayName}")
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey)),
                    child: const Icon(Icons.logout_sharp),
                    onPressed: () {
                      // Signing out the user
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignIn()),
              (route) => false,
            );
          }
        },
        child: TemplatesPage(),
      ),
    );
  }
}
