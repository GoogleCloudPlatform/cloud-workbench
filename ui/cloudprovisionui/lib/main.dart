import 'package:cloudprovision/blocs/auth/auth_bloc.dart';
import 'package:cloudprovision/repository/auth_repository.dart';
import 'package:cloudprovision/repository/service/auth_service.dart';
import 'package:cloudprovision/ui/main/main_screen.dart';
import 'package:cloudprovision/ui/signin/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/env");

  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseOptions from Firebase console - web app config
  // Set values in assets/.env
  // example: PROJECT_ID="your-project-name"
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: dotenv.get('API_KEY'),
        authDomain: dotenv.get('AUTH_DOMAIN'),
        projectId: dotenv.get('PROJECT_ID'),
        storageBucket: dotenv.get('STORAGE_BUCKET'),
        messagingSenderId: dotenv.get('MESSAGING_SENDER_ID'),
        appId: dotenv.get('APP_ID'),
        measurementId: dotenv.get('MEASUREMENT_ID')),
  );
  runApp(const CloudProvisionApp());
}

class CloudProvisionApp extends StatelessWidget {
  const CloudProvisionApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(service: AuthService()),
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
                // If the snapshot has user data, then they're already signed in. So Navigating to the Main Screen.
                if (snapshot.hasData) {
                  return const MainScreen();
                }
                // Otherwise, they're not signed in. Show the sign in page.
                return const SignIn();
              }),
        ),
      ),
    );
  }
}
