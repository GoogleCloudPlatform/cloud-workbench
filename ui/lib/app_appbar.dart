import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'modules/auth/repositories/auth_provider.dart';

class App_AppBar extends ConsumerWidget implements PreferredSizeWidget {
  App_AppBar({
    super.key,
  });

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.read(authRepositoryProvider);

    return AppBar(
      elevation: 1,
      shadowColor: Colors.black38,
      iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
      leadingWidth: 35,
      title: InkWell(
          onTap: () {
            context.go('/home');
          },
          child: Row(
            children: [
              Image(
                image: AssetImage('images/cloud_logo.png'),
              ),
              Text(
                '  Developer Workbench',
                style: Theme.of(context).textTheme.titleLarge?.merge(
                      TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                    ),
              ),
            ],
          )
          //
          ),
      //backgroundColor: Theme.of(context).primaryColor,
      actions: [
        Row(
          children: [
            user.displayName != null
                ? Tooltip(
                    message: "${user.email}",
                    child: Text("${user.displayName}",
                        style: TextStyle(color: Colors.black87)),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(8),
                ),
                child: const Icon(Icons.logout_sharp),
                onPressed: () {
                  authRepo.signOut();
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(40.0);
}
