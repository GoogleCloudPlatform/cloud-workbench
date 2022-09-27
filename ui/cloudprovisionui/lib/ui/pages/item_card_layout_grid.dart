import 'package:cloudprovision/ui/main/main_screen.dart';
import 'package:cloudprovision/ui/pages/workspace_overview.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCardLayoutGrid extends StatelessWidget {
  final void Function(NavigationPage page) navigateTo;

  const ItemCardLayoutGrid(
      {Key? key,
      required this.crossAxisCount,
      required this.items,
      required this.navigateTo})
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
        for (var i = 0; i < items.length; i++) _card(items[i]),
      ],
    );
  }

  Widget _card(SectionItem sectionItem) {
    return SizedBox(
      width: 296.0,
      height: 240.0,
      child: Card(
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: () {
            navigateTo(sectionItem.page);
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
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image(
                        image: AssetImage('images/${sectionItem.image}.png'),
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
                            Text(
                              sectionItem.title,
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: Color(0xFF1b3a57),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              sectionItem.subTitle,
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                color: Color(0xFF1b3a57),
                              ),
                            ),
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
