import 'package:cloudprovision/bloc/bloc/auth_bloc.dart';
import 'package:cloudprovision/data/repositories/auth_repository.dart';
import 'package:cloudprovision/presentation/Dashboard/dashboard.dart';
import 'package:cloudprovision/presentation/SignIn/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO set FirebaseOptions from Firebase console - web app config

  await Firebase.initializeApp(
    options: const FirebaseOptions(

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();

    return RepositoryProvider(
      create: (context) => authRepository,
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<User?>(
              //GoogleSignInAccount
              stream: FirebaseAuth.instance
                  .authStateChanges(), //authRepository.onCurrentUserChanged,
              builder: (context, snapshot) {
                // If the snapshot has user data, then they're already signed in. So Navigating to the Dashboard.
                if (snapshot.hasData) {
                  return const Dashboard();
                }
                // Otherwise, they're not signed in. Show the sign in page.
                return const SignIn();
              }),
        ),
      ),
    );
  }
}
