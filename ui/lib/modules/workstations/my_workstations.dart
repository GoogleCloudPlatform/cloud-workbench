import 'dart:math';

import 'package:cloud_provision_shared/services/models/workstation.dart';
import 'package:cloudprovision/widgets/cloud_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/environment.dart';
import '../../utils/styles.dart';

import '../my_services/data/cloud_workstations_repository.dart';
import '../settings/data/settings_repository.dart';

class MyWorkstationsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;

    final ldap = user.email.toString().split('@')[0];

    return Column(
      children: [
        _buildSubHead(context),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Available Workstations  (${ldap})",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      tooltip: 'Refresh',
                      onPressed: () async {
                        ref.invalidate(allWorkstationsProvider);
                      },
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildWorkstationsList(context: context, ref: ref),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildWorkstationsList(
      {required BuildContext context, required WidgetRef ref}) {
    // String projectId = Environment.getProjectId();
    String region = Environment.getRegion();

    // String projectId = ref.read(projectDropdownProvider.notifier).state;
    var settings = ref.watch(gitSettingsProvider);

    return settings.when(
      loading: () => Text('Loading...'),
      error: (err, stack) => Text('Error: $err'),
      data: (settings) {

        var projectId = settings.targetProject;

        final workstationsList = ref.watch(allWorkstationsProvider(
            projectId: projectId,
            clusterName: Environment.getWorkstationCluster(),
            region: region));

        return workstationsList.when(
          loading: () => Text('Loading...'),
          error: (err, stack) => Text('Error: $err'),
          data: (wrkList) {
            return _buildWorkstationRows(wrkList, ref, projectId, region);
          },
        );
      },
    );
  }

  _buildSubHead(BuildContext context) {
    return Column(
      children: [
        Divider(color: Colors.black38),
        Container(
          padding: EdgeInsets.only(left: 20),
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Workstations",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        Divider(color: Colors.black38),
      ],
    );
  }

  Widget _buildWorkstationRows(List<Workstation> wrkList, WidgetRef ref,
      String projectId, String region) {
    final user = FirebaseAuth.instance.currentUser!;

    final ldap = user.email.toString().split('@')[0];

    List<TableRow> rows = [];
    wrkList.map(
      (workstation) {
        if (workstation.name.contains(ldap)) {
          rows.add(
            TableRow(
              children: [
                CloudTableCell(
                    child: CloudTableCellText(text: workstation.displayName)),

                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () async {
                    launchUrl(Uri.parse("https://80-${workstation.host}"));
                  },
                  child: Text(
                    workstation.host,
                    style: AppText.linkFontStyle,
                  ),
                ),
                // CloudTableCell(
                //   child: CloudTableCellText(text: workstation.host),
                // ),
                CloudTableCell(
                    child: CloudTableCellText(text: workstation.state)),

                CloudTableCell(
                  child: TextButton(
                    onPressed: () async {
                      launchUrl(Uri.parse("https://80-${workstation.host}"));
                    },
                    child: Text(
                      "LAUNCH",
                      style: AppText.linkFontStyle,
                    ),
                  ),
                ),

                CloudTableCell(
                  child: TextButton(
                    onPressed: () async {
                      ref
                          .watch(cloudWorkstationsRepositoryProvider)
                          .startInstance(
                              projectId,
                              workstation.clusterName,
                              workstation.configName,
                              workstation.displayName,
                              region);
                      ref.invalidate(allWorkstationsProvider);
                    },
                    child: Text(
                      "Start",
                      style: AppText.linkFontStyle,
                    ),
                  ),
                ),
                CloudTableCell(
                  child: TextButton(
                    onPressed: () async {
                      ref
                          .watch(cloudWorkstationsRepositoryProvider)
                          .stopInstance(
                              projectId,
                              workstation.clusterName,
                              workstation.configName,
                              workstation.displayName,
                              region);
                      ref.invalidate(allWorkstationsProvider);
                    },
                    child: Text(
                      "Stop",
                      style: AppText.linkFontStyle,
                    ),
                  ),
                ),
                CloudTableCell(
                  child: TextButton(
                    onPressed: () async {
                      ref
                          .watch(cloudWorkstationsRepositoryProvider)
                          .deleteInstance(
                              projectId,
                              workstation.clusterName,
                              workstation.configName,
                              workstation.displayName,
                              region);
                      ref.invalidate(allWorkstationsProvider);
                    },
                    child: Text(
                      "Delete",
                      style: AppText.linkFontStyle,
                    ),
                  ),
                ),
                CloudTableCell(
                    child: CloudTableCellText(text: workstation.configName)),
              ],
            ),
          );
        }
      },
    ).toList();
    rows.insert(
      0,
      TableRow(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.04),
        ),
        children: [
          CloudTableCell(child: CloudTableCellText(text: "Name")),
          CloudTableCell(child: CloudTableCellText(text: "Host")),
          CloudTableCell(child: CloudTableCellText(text: "State")),
          CloudTableCell(child: CloudTableCellText(text: "Action")),
          CloudTableCell(child: CloudTableCellText(text: "")),
          CloudTableCell(child: CloudTableCellText(text: "")),
          CloudTableCell(child: CloudTableCellText(text: "")),
          CloudTableCell(child: CloudTableCellText(text: "Config")),
        ],
      ),
    );

    return CloudTable(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(7),
      },
      children: rows,
    );
  }
}
