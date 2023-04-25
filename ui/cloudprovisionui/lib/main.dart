import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/app/app_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'repository/auth_repository.dart';
import 'repository/firebase_repository.dart';
import 'repository/service/auth_service.dart';
import 'repository/service/firebase_service.dart';
import 'theme.dart';
import 'ui/main/main_screen.dart';

import 'ui/signin/sign_in.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/env");

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Uncomment to run with local Firebase emulator

  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8088);
  //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  runApp(const CloudProvisionApp());
}

class CloudProvisionApp extends StatelessWidget {
  const CloudProvisionApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirebaseRepository(
          service: FirebaseService(FirebaseFirestore.instance,
              FirebaseAuth.instance.currentUser!.uid)),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (BuildContext context) =>
                AppBloc(firebaseRepository: context.read<FirebaseRepository>())
                  ..add(GetAppState()),
          ),
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
              authRepository: AuthRepository(service: AuthService()),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: CloudTheme().themeData,
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
