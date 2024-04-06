import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tillkhatam/core/app_asset.dart';
import 'package:tillkhatam/core/app_color.dart';
import 'package:tillkhatam/core/app_helper.dart';
import 'package:tillkhatam/core/app_style.dart';
import 'package:tillkhatam/src/business_logic/provider/theme_provider.dart';
import 'package:tillkhatam/src/presentation/widget/page_initialize_dialog.dart';
import 'package:tillkhatam/src/presentation/widget/page_notification_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void initState() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      print(purchaseDetailsList);
      _listenToPurchaseUpdated(context, purchaseDetailsList);
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      print(error);
    }) as StreamSubscription<List<PurchaseDetails>>?;
    super.initState();
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  bool _verifyPurchase(PurchaseDetails purchaseDetails) {
    return purchaseDetails.productID == dotenv.env['SKU_01'];
  }

  onValidPurchase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppHelper.pref2, true);
  }

  void _listenToPurchaseUpdated(
      context, List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        AppHelper.snackbar(context, "Pending Purchase");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          AppHelper.snackbar(context, purchaseDetails.error!.message);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = _verifyPurchase(purchaseDetails);
          if (valid) {
            onValidPurchase();
          } else {
            AppHelper.snackbar(
                context, "Invalid Purchase : ${purchaseDetails.error}");
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: Center(
                child: Image.asset(
                  Provider.of<ThemeProvider>(context, listen: false).theme ==
                          'hafiz'
                      ? AppAsset.hafiz_1
                      : AppAsset.sakinah_1,
                  height: 238,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 180,
                ),
                SectionGroup(),
                const SizedBox(
                  height: 42,
                ),
                SectionGroup2(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card SectionGroup() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            // ListTile(
            //   title: const Text("Language"),
            //   leading: const Icon(Icons.language),
            //   trailing: Icon(
            //     Icons.chevron_right,
            //     color: Colors.grey[500],
            //   ),
            //   dense: true,
            // ),
            // Divider(
            //   color: Colors.grey[300],
            // ),
            ListTile(
              onTap: () {
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      actions: <Widget>[
                        GestureDetector(
                          child: Column(
                            children: [
                              FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColor.lightPink,
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Sakinah',
                                    style: AppStyle.text(context).copyWith(
                                      color: AppColor.lightWhite,
                                    ),
                                  ),
                                ),
                              ),
                              Image.asset(
                                AppAsset.theme_icon_f,
                                height: 68,
                              ),
                            ],
                          ),
                          onTap: () {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .setTheme('sakinah');
                            Navigator.of(context).pop(); // Dismiss the dialog
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColor.lightGreen,
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'Hafiz',
                                    style: AppStyle.text(context)
                                        .copyWith(color: AppColor.lightWhite),
                                  ),
                                ),
                              ),
                              Image.asset(
                                AppAsset.theme_icon_m,
                                height: 68,
                              ),
                            ],
                          ),
                          onTap: () {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .setTheme('hafiz');
                            Navigator.of(context).pop(); // Dismiss the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              title: const Text("Theme"),
              leading: const Icon(Icons.format_paint),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
              dense: true,
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: const Text("Dark Mode"),
              dense: true,
              trailing: Switch.adaptive(
                value: isDarkMode,
                inactiveThumbColor: AppColor.lightWhite,
                inactiveTrackColor: AppColor.lightGray,
                trackOutlineColor: MaterialStateProperty.resolveWith(
                  (final Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return null;
                    }

                    return AppColor.lightWhite;
                  },
                ),
                activeColor:
                    Provider.of<ThemeProvider>(context, listen: false).theme ==
                            'hafiz'
                        ? AppColor.lightGreen
                        : AppColor.lightPink,
                onChanged: (bool value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkStoreAndRestore(context) async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      AppHelper.snackbar(context, "Store not available");
    }
    await InAppPurchase.instance.restorePurchases();
  }

  disableAds(context) async {
    Set<String> kIds = <String>{dotenv.env['SKU_01']!};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(kIds);
    if (response.notFoundIDs.isNotEmpty) {
      print("sku not found");
    }
    List<ProductDetails> products = response.productDetails;
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: products[0]);
    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Card SectionGroup2() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            ListTile(
              title: const Text("Notification"),
              leading: const Icon(Icons.alarm),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
              dense: true,
              onTap: () {
                showDialog<String>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) =>
                      const PageNotificationDialog(),
                );
              },
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: const Text("Reset"),
              leading: const Icon(Icons.restore),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
              dense: true,
              onTap: () {
                showDialog<String>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) =>
                      const PageInitializeDialog(),
                );
              },
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: const Text("Disable Ads"),
              leading: const Icon(Icons.store),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
              dense: true,
              onTap: () {
                disableAds(context);
              },
            ),
            Divider(
              color: Colors.grey[300],
            ),
            ListTile(
              title: const Text("Restore Purchases"),
              leading: const Icon(Icons.restore),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey[500],
              ),
              dense: true,
              onTap: () {
                checkStoreAndRestore(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
