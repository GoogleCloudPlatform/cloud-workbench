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

import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_body.dart';

class ItemCardLayoutGrid extends StatelessWidget {
  const ItemCardLayoutGrid(
      {Key? key, required this.crossAxisCount, required this.items})
      // we only plan to use this with 1 or 2 columns
      : super(key: key);
  final int crossAxisCount;
  final List<SectionItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      // set some flexible track sizes based on the crossAxisCount
      columnSizes:
          crossAxisCount == 3 ? [300.px, 300.px, 300.px] : [300.px, 300.px],
      // set all the row sizes to auto (self-sizing height)
      rowSizes: crossAxisCount == 3
          ? const [auto, auto]
          : const [auto, auto, auto, auto],
      rowGap: 10, // equivalent to mainAxisSpacing
      columnGap: 10, // equivalent to crossAxisSpacing
      // note: there's no childAspectRatio
      children: [
        // render all the cards with *automatic child placement*
        for (var i = 0; i < items.length; i++) _card(items[i], context),
      ],
    );
  }

  Widget _card(SectionItem sectionItem, BuildContext context) {
    return SizedBox(
      width: 296.0,
      height: 240.0,
      child: Card(
        child: InkWell(
          onTap: () {
            //navigateTo(sectionItem.page);
            print(sectionItem.dest);
            context.go(sectionItem.dest);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child: Container(
              height: 240,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 125,
                    child: Material(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: new BorderRadius.only(
                      //     topLeft: Radius.circular(8),
                      //     topRight: Radius.circular(8),
                      //   ),
                      // ),
                      clipBehavior: Clip.antiAlias,
                      child: Image(
                        image: AssetImage('assets/images/${sectionItem.image}.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 12, right: 12),
                    child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(sectionItem.title,
                                style: Theme.of(context).textTheme.bodyLarge),
                            SizedBox(height: 5),
                            Text(sectionItem.subTitle,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
