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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'modules/auth/repositories/auth_provider.dart';

class App_AppBar extends ConsumerWidget implements PreferredSizeWidget {
  App_AppBar({
    super.key,
  });

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
                image: AssetImage('assets/images/cloud_logo.png'),
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
            authRepo.currentUser()!.displayName != null
                ? Tooltip(
                    message: "${authRepo.currentUser()!.email}",
                    child: Text("${authRepo.currentUser()!.displayName}",
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
