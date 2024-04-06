import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:jhijri/_src/_jHijri.dart';
import 'package:provider/provider.dart';
import 'package:tillkhatam/core/app_color.dart';
import 'package:tillkhatam/core/app_helper.dart';
import 'package:tillkhatam/core/app_style.dart';
import 'package:tillkhatam/src/business_logic/provider/quran_provider.dart';
import 'package:tillkhatam/src/data/model/user.dart';

class PageInitializeDialog extends StatefulWidget {
  const PageInitializeDialog({super.key});

  @override
  State<PageInitializeDialog> createState() => _PageInitializeDialogState();
}

class _PageInitializeDialogState extends State<PageInitializeDialog> {
  final today = DateUtils.dateOnly(DateTime.now());
  String khatamDate = "Set Date";
  String khatamDateDB = "";
  String khatamDateHijiri = "";
  TextEditingController currentCtrl = TextEditingController();
  TextEditingController totalCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          margin: const EdgeInsets.all(5.0),
          //padding: const EdgeInsets.only(top: 23),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                //width: 280,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        'Answer Please',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              const SizedBox(height: 15),
              Text(
                'When do you intent to khatam',
                style: AppStyle.text(context, color: AppColor.lightBlack),
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () async {
                  final date = await showDatePickerDialog(
                    context: context,
                    minDate: today,
                    maxDate: today.add(const Duration(days: 365)),
                  );

                  final jHijri =
                      JHijri(fDate: date, fDisplay: DisplayFormat.MMMDDYYYY);
                  setState(() {
                    khatamDate = AppHelper.formatDate(date!);
                    khatamDateDB = date.toIso8601String();
                    khatamDateHijiri = jHijri.toString();
                  });
                },
                style: AppStyle.button(context,
                    color: Theme.of(context).colorScheme.primary),
                child: Text(
                  khatamDate,
                  style: AppStyle.text(context),
                ),
              ),
              Text(
                khatamDateHijiri,
                style: AppStyle.text(context),
              ),
              const SizedBox(height: 15),
              Text(
                textAlign: TextAlign.center,
                'What page of the Quran are you at currently?',
                style: AppStyle.text(context, color: AppColor.lightBlack),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: currentCtrl,
                  keyboardType: TextInputType.number,
                  style: AppStyle.bigtitle(context,
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                  decoration: AppStyle.textInput(context, hint: "5"),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'How many pages does your Quran have?',
                style: AppStyle.text(context, color: AppColor.lightBlack),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: totalCtrl,
                  keyboardType: TextInputType.number,
                  style: AppStyle.bigtitle(context,
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                  decoration: AppStyle.textInput(context, hint: "5"),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                //width: 280,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16))),
                child: InkWell(
                  onTap: () {
                    if (currentCtrl.text.isNotEmpty) {
                      User user = User(
                          user_finish_date: khatamDateDB,
                          user_currentpage: int.parse(currentCtrl.text),
                          user_allpage: int.parse(totalCtrl.text));
                      Provider.of<QuranProvider>(context, listen: false)
                          .createUser(user);
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Center(
                        child: Text(
                          'OK',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
