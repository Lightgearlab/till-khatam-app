import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tillkhatam/core/app_color.dart';
import 'package:tillkhatam/core/app_helper.dart';
import 'package:tillkhatam/src/business_logic/provider/quran_provider.dart';
import 'package:tillkhatam/src/data/model/read.dart';
import 'package:tillkhatam/src/data/model/user.dart';
import 'package:tillkhatam/src/presentation/widget/read_list_view.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<String> dates = [];
  Map<DateTime, int> readingDate = <DateTime, int>{};
  @override
  Widget build(BuildContext context) {
    final User? userdata = context.watch<QuranProvider>().getUser;
    final List<Read>? listread = context.watch<QuranProvider>().getReadList;
    listread?.forEach((e) {
      DateTime eDT = DateTime.parse(e.reading_date);
      var format = DateFormat('yyyy-MM-dd');
      eDT = DateTime.parse(format.format(eDT));
      String eFmt = AppHelper.formatDate(eDT);
      if (!dates.contains(eFmt)) {
        dates.add(eFmt);
        readingDate.addAll(<DateTime, int>{eDT: 1});
      } else {
        readingDate[eDT] = readingDate[eDT]! + 1;
      }
    });

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: HeatMap(
                  textColor: AppColor.lightBlack,
                  startDate: listread!.isNotEmpty
                      ? DateTime.parse(listread[0].reading_date)
                      : DateTime.now(), //get from start date
                  endDate: DateTime.parse(
                      userdata!.user_finish_date!), // get from khatam date
                  datasets: readingDate,
                  colorMode: ColorMode.opacity,
                  showText: false,
                  scrollable: true,
                  colorsets: {
                    1: Theme.of(context).primaryColor,
                    // 3: Colors.orange,
                    // 5: Colors.yellow,
                    // 7: Colors.green,
                    // 9: Colors.blue,
                    // 11: Colors.indigo,
                    // 13: Colors.purple,
                  },
                  onClick: (value) {
                    AppHelper.snackbar(context, value.toString());
                  },
                ),
              ),
            ),
            Expanded(
              child: Card(
                elevation: 10,
                child: ReadListView(
                    list: context.watch<QuranProvider>().getReadList!),
              ),
            )
          ],
        ),
      ),
    );
  }
}
