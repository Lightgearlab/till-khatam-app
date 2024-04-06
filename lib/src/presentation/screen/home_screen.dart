import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tillkhatam/core/app_asset.dart';
import 'package:tillkhatam/core/app_color.dart';
import 'package:tillkhatam/core/app_helper.dart';
import 'package:tillkhatam/core/app_route.dart';
import 'package:tillkhatam/core/app_style.dart';
import 'package:tillkhatam/src/business_logic/provider/quran_provider.dart';
import 'package:tillkhatam/src/business_logic/provider/theme_provider.dart';
import 'package:tillkhatam/src/data/model/user.dart';
import 'package:tillkhatam/src/presentation/widget/page_counter_dialog.dart';
import 'package:tillkhatam/src/presentation/widget/page_initialize_dialog.dart';
import 'package:tillkhatam/src/presentation/widget/read_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShown = false;
  bool isNoAds = false;

  checkFirstTime(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(AppHelper.pref3)) {
      var user = Provider.of<QuranProvider>(context, listen: false).getUser;
      if (!isShown && user == null) {
        showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const PageInitializeDialog(),
        ).then((value) {
          Provider.of<QuranProvider>(context, listen: false).init();
          Navigator.of(context).pushReplacementNamed(AppRoute.HOME);
        });
        await prefs.setBool(AppHelper.pref3, true);
        setState(() {
          isShown = true;
        });
      }
    }
    if (prefs.containsKey(AppHelper.pref2) ||
        dotenv.env['DISABLE_ADS'] == "true") {
      setState(() {
        isNoAds = true;
      });
    }
  }

  @override
  void initState() {
    checkFirstTime(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? userdata = context.watch<QuranProvider>().getUser;
    if (userdata == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Loading..',
            style: AppStyle.text(context, color: AppColor.lightBlack),
          ),
        ),
      );
    }
    DateTime targetDate = DateTime.parse(userdata.user_finish_date!);
    DateTime today = DateTime.now();
    int dateDiff = targetDate.difference(today).inDays;
    int pageDiff = userdata.user_allpage! - userdata.user_currentpage;
    int pagePerDay = pageDiff ~/ dateDiff;
    double pagePerSalah = pagePerDay / 5;

    return Scaffold(
      floatingActionButton: Container(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                onPressed: () {
                  var readdata =
                      Provider.of<QuranProvider>(context, listen: false)
                          .getReadList;
                  var res = readdata?.fold(
                      0,
                      (previousValue, element) =>
                          previousValue + element.pages_read);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => PageCounterDialog(
                      pageTarget: pagePerDay,
                      pageToday: res,
                      isAdDisabled: isNoAds,
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            ],
          )),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Text(
                      '${userdata.user_currentpage.toString()}/${userdata.user_allpage.toString()}',
                      style: AppStyle.bigtitle(
                        context,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  line(context, pagePerDay.toString(), " page/s per day"),
                  line(context, pagePerSalah.toString(), " page/s per Salah"),
                  line(context, "$pageDiff/${userdata.user_allpage}",
                      " page left"),
                  line(context, dateDiff.toString(), " days left until ",
                      textEnd: AppHelper.formatDate(
                          DateTime.parse(userdata.user_finish_date!))),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ReadListView(
                          list:
                              context.watch<QuranProvider>().getReadListToday!),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: -30,
              left: 0,
              child: Image.asset(
                Provider.of<ThemeProvider>(context, listen: false).theme ==
                        'hafiz'
                    ? AppAsset.hafiz_1
                    : AppAsset.sakinah_1,
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  line(context, textNumber, text, {textEnd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textNumber,
          style: AppStyle.subtitle(context, fontWeight: FontWeight.bold),
        ),
        Text(
          text,
          style: AppStyle.text(context),
        ),
        if (textEnd != null)
          Text(
            textEnd,
            style: AppStyle.subtitle(context, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
