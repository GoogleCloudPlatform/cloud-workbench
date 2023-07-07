import 'dart:async';

import 'package:cloud_provision_shared/services/models/workstation.dart';
import 'package:cloudprovision/modules/my_services/models/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/cloud_workstations_repository.dart';

class WorkStationWidget extends ConsumerStatefulWidget {
  final Service service;
  const WorkStationWidget(this.service, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WorkStationWidgetState();
}

class _WorkStationWidgetState extends ConsumerState<WorkStationWidget> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final ldap = user.email.toString().split('@')[0];
    final email = user.email;

    List<Widget> children = [];

    final workstationsList = ref.watch(workstationsProvider(
      projectId: widget.service.projectId,
      clusterName: widget.service.workstationCluster,
      configName: widget.service.workstationConfig,
      region: widget.service.region,
    ));

    workstationsList.when(
      loading: () => Text('Loading...'),
      error: (err, stack) => Text('Error: $err'),
      data: (wrkList) {
        wrkList.forEach((wkstn) {
          if (wkstn.name.contains(ldap)) {
            children.add(Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _getStatusIcon(workstation: wkstn),
                SizedBox(width: 15),
                Text(wkstn.displayName),
                SizedBox(width: 15),
                _getActionButton(
                    workstation: wkstn, context: context, ref: ref),
                SizedBox(width: 15),
                wkstn.state.contains("RUNNING")
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: () async {
                          launchUrl(Uri.parse("https://80-${wkstn.host}"));
                        },
                        child: Text(
                          "Launch",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : Container(),
                SizedBox(width: 15),
                wkstn.state.isNotEmpty
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(0),
                        ),
                        onPressed: () async {
                          await ref
                              .watch(cloudWorkstationsRepositoryProvider)
                              .deleteInstance(
                                  widget.service.projectId,
                                  wkstn.clusterName,
                                  wkstn.configName,
                                  wkstn.displayName,
                                  widget.service.region);
                          ref.invalidate(workstationsProvider);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : Container(),
              ],
            ));
          }
        });
        if (children.length == 0) {
          children.add(SizedBox(
            height: 5,
          ));
          children.add(
              Text("No workstations found for this user config combination"));
          children.add(SizedBox(
            height: 5,
          ));
          children.add(
            InkWell(
              onTap: () async {
                await ref
                    .watch(cloudWorkstationsRepositoryProvider)
                    .createInstance(
                        widget.service.projectId,
                        widget.service.workstationCluster,
                        widget.service.workstationConfig,
                        "${ldap}-${widget.service.workstationConfig}",
                        widget.service.region,
                        email!);
                ref.invalidate(workstationsProvider);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add_box,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    "Create Workstation",
                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                          TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          );
        }
        ;
      },
    );

    children.insert(
        0,
        Row(
          children: [
            Text(
              "Related Workstations",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              tooltip: 'Refresh',
              onPressed: () async {
                ref.invalidate(workstationsProvider);
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.blue,
              ),
            ),
          ],
        ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _getStatusIcon({required Workstation workstation}) {
    Widget child = Container();

    var doneIcon = Icon(
      Icons.check_circle_rounded,
      color: Colors.green,
    );

    if (workstation.state.contains("STOPPED")) {
      child = Icon(Icons.stop_circle);
    }
    if (workstation.state.contains("RUNNING")) {
      child = doneIcon;
    }
    if (workstation.state.contains("STARTING")) {

      var inProgressIcon = Row(
            children: [
              SizedBox(
                child: CircularProgressIndicator(strokeWidth: 2),
                height: 15,
                width: 15,
              ),
              SizedBox(
                width: 5,
              )
            ],
          );

      final workstationStartingProgress = ref.watch(workstationStartingProgressProvider(projectId: widget.service.projectId,
        clusterName: workstation.clusterName,
        configName: workstation.configName,
        instanceName: workstation.displayName,
        region: widget.service.region,
      ));

      child = workstationStartingProgress.when(
        data: (inProgress) {
          if (inProgress) {
            return inProgressIcon;
          } else {
            return doneIcon;
          }
        },
        loading: () => inProgressIcon,
        error: (err, stack) {
          print(err);
          return Container();
          },
      );
    }

    return child;
  }

  Widget _getActionButton({
    required BuildContext context,
    required WidgetRef ref,
    required Workstation workstation,
  }) {
    Widget actionButton = Container();

    if (workstation.state.contains("STARTING")) {
      //while (workstation.state.contains("STARTING")) {
      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   setState(() {});
      // });
      //}

      final workstationStartingProgress = ref.watch(workstationStartingProgressProvider(projectId: widget.service.projectId,
        clusterName: workstation.clusterName,
        configName: workstation.configName,
        instanceName: workstation.displayName,
        region: widget.service.region,
      ));

      actionButton = workstationStartingProgress.when(
        data: (inProgress) {
          if (!inProgress) {
            return TextButton(
              child: Text("Stop"),
              onPressed: () async {
                await ref.watch(cloudWorkstationsRepositoryProvider).stopInstance(
                    widget.service.projectId,
                    workstation.clusterName,
                    workstation.configName,
                    workstation.displayName,
                    widget.service.region);
                ref.invalidate(workstationsProvider);
              },
            );
          } else {
            return Container();
          }

        },
        loading: () => Container(),
        error: (err, stack) {
          print(err);
          return Container();
        },
      );
    }
    if (workstation.state.contains("STOPPED")) {
      actionButton = TextButton(
        child: Text("Start"),
        onPressed: () async {
          await ref.watch(cloudWorkstationsRepositoryProvider).startInstance(
              widget.service.projectId,
              workstation.clusterName,
              workstation.configName,
              workstation.displayName,
              widget.service.region);
          ref.invalidate(workstationsProvider);

        },
      );
    }
    if (workstation.state.contains("RUNNING")) {
      actionButton = TextButton(
        child: Text("Stop"),
        onPressed: () async {
          await ref.watch(cloudWorkstationsRepositoryProvider).stopInstance(
              widget.service.projectId,
              workstation.clusterName,
              workstation.configName,
              workstation.displayName,
              widget.service.region);
          ref.invalidate(workstationsProvider);
        },
      );
    }
    return actionButton;
  }
}
