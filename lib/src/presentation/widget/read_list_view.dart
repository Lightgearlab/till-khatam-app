import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:tillkhatam/core/app_color.dart';
import 'package:tillkhatam/core/app_style.dart';
import 'package:tillkhatam/src/data/model/read.dart';

class ReadListView extends StatelessWidget {
  const ReadListView({super.key, required this.list});
  final List<Read> list;
  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? Container()
        : GroupedListView<Read, String>(
            elements: list,
            groupBy: (element) {
              var format = DateFormat('dd-MMM-yyyy');
              return format.format(DateTime.parse(element.reading_date));
            },
            groupSeparatorBuilder: (String groupByValue) => Padding(
              padding: const EdgeInsets.only(
                left: 32.0,
                bottom: 8,
                top: 16,
              ),
              child: Text(
                groupByValue,
                style: AppStyle.text(context, fontWeight: FontWeight.bold),
              ),
            ),
            itemBuilder: (context, dynamic element) => readList(
              context,
              element,
            ),
          );
  }

  readList(context, Read read) {
    DateTime dateTime = DateTime.parse(read.reading_date);
    String formattedTime = DateFormat('hh:mm a').format(dateTime.toLocal());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .primary, // Change border color as needed
          width: 2, // Change border width as needed
        ),
      ),
      child: ListTile(
        leading: const Icon(
          Icons.auto_stories,
          color: AppColor.lightWhite,
        ),
        title: Text(
          formattedTime,
          style: AppStyle.text(context).copyWith(color: AppColor.lightWhite),
        ),
        subtitle: Text(
          'Read ${read.pages_read.toString()} page',
          style: AppStyle.text(context).copyWith(
              color: AppColor.lightWhite, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
