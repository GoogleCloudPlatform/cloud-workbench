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

import 'package:flutter/material.dart';

class CloudTable extends StatelessWidget {
  final children;
  final columnWidths;
  const CloudTable({
    super.key,
    this.children,
    this.columnWidths,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Color.fromRGBO(112, 112, 112, .4),
          width: .5,
        ),
        bottom: BorderSide(
          color: Color.fromRGBO(112, 112, 112, .2),
          width: .75,
        ),
      ),
      columnWidths: columnWidths,
      children: children,
    );
  }
}

// class CloudTableRow extends StatelessWidget implements TableRow {
//   final children;
//   final decoration;
//   const CloudTableRow({
//     super.key,
//     required this.children,
//     this.decoration,
//   });

//   @override
//   Widget build(BuildContext context) {
//     //return Container();
//     return TableRow(children: children) as Widget;
//   }

//   @override
//   // TODO: implement decoration
//   Decoration? get decoration => decoration;
// }

class CloudTableCell extends StatelessWidget {
  final Widget child;
  const CloudTableCell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 8, bottom: 8),
      child: child,
    );
  }
}

class CloudTableCellText extends StatelessWidget {
  final String text;
  const CloudTableCellText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.merge(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          ),
    );
  }
}

class ExampleTable extends StatelessWidget {
  const ExampleTable({super.key});

  @override
  Widget build(BuildContext context) {
    return CloudTable(
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(4),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.04),
            ),
            children: [
              CloudTableCell(child: CloudTableCellText(text: "Product Name")),
              CloudTableCell(child: CloudTableCellText(text: "Description")),
              CloudTableCell(child: CloudTableCellText(text: "Category")),
            ]),
        TableRow(children: [
          CloudTableCell(child: CloudTableCellText(text: "Cloud Run")),
          CloudTableCell(
              child: CloudTableCellText(
                  text: "Serverless for containerized applications")),
          CloudTableCell(child: CloudTableCellText(text: "Serverless")),
        ]),
        TableRow(children: [
          CloudTableCell(child: CloudTableCellText(text: "SQL")),
          CloudTableCell(
              child: CloudTableCellText(
                  text: "Managed MySQL, PostgreSQL, SQL Server")),
          CloudTableCell(child: CloudTableCellText(text: "Databases")),
        ]),
        TableRow(children: [
          CloudTableCell(child: CloudTableCellText(text: "Memory Store")),
          CloudTableCell(
              child: CloudTableCellText(text: "Managed Redis and Memcached")),
          CloudTableCell(child: CloudTableCellText(text: "Databases")),
        ]),
        TableRow(children: [
          CloudTableCell(child: CloudTableCellText(text: "VPC Network")),
          CloudTableCell(
              child: CloudTableCellText(text: "Virtual private cloud")),
          CloudTableCell(child: CloudTableCellText(text: "Networking")),
        ]),
      ],
    );
  }
}
