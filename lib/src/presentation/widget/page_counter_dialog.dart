import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tillkhatam/core/app_color.dart';
import 'package:tillkhatam/core/app_style.dart';
import 'package:tillkhatam/src/business_logic/provider/quran_provider.dart';
import 'package:tillkhatam/src/data/model/read.dart';
import 'package:tillkhatam/src/data/model/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PageCounterDialog extends StatefulWidget {
  const PageCounterDialog(
      {super.key,
      required this.pageTarget,
      required this.pageToday,
      required this.isAdDisabled});
  final int? pageToday, pageTarget;
  final bool? isAdDisabled;
  @override
  State<PageCounterDialog> createState() => _PageCounterDialogState();
}

class _PageCounterDialogState extends State<PageCounterDialog> {
  InterstitialAd? _interstitiaAd;
  final adUnitId = Platform.isAndroid
      ? dotenv.env['ANDROID_ADS']
      : dotenv.env['IOS_ADS'];
  void loadAd() async {
    await InterstitialAd.load(
        adUnitId: adUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            _interstitiaAd = ad;
            _interstitiaAd!.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  TextEditingController readCtrl = TextEditingController();
  int totalPageToday = 0;
  @override
  void initState() {
    if (!widget.isAdDisabled!) {
      loadAd();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? userdata = context.watch<QuranProvider>().getUser;
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.only(top: 23),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Currently at page'),
            const SizedBox(height: 15),
            Text(
              userdata!.user_currentpage.toString(),
              style: AppStyle.title(context, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text("I've read until page"),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: readCtrl,
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    setState(() {
                      totalPageToday =
                          int.parse(text) - userdata.user_currentpage;
                    });
                  }
                },
                keyboardType: TextInputType.number,
                style: AppStyle.title(context,
                    color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.center,
                decoration: AppStyle.textInput(context,
                    hint: "${userdata.user_currentpage + 1}",
                    hintStyle:
                        AppStyle.title(context, color: AppColor.lightGray)),
              ),
            ),
            const Text("Total page read today"),
            Text(
              '$totalPageToday/${widget.pageTarget}',
              style: AppStyle.title(context, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              // width: 280,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (totalPageToday > 0) {
                          Read read = Read(
                            pages_read: totalPageToday,
                            reading_date: DateTime.now().toIso8601String(),
                          );
                          Provider.of<QuranProvider>(context, listen: false)
                              .addRead(read);
                        }
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Confirm',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
