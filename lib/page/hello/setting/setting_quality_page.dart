/*
 * Copyright (C) 2020. by perol_notsf, All rights reserved
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see <http://www.gnu.org/licenses/>.
 *
 */

import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pixez/constants.dart';
import 'package:pixez/er/leader.dart';
import 'package:pixez/i18n.dart';
import 'package:pixez/main.dart';
import 'package:pixez/models/glance_illust_persist.dart';
import 'package:pixez/page/about/languages.dart';
import 'package:pixez/page/hello/setting/copy_text_page.dart';
import 'package:pixez/page/hello/setting/setting_cross_adapter_page.dart';
import 'package:pixez/page/network/network_page.dart';
import 'package:pixez/page/platform/platform_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingQualityPage extends StatefulWidget {
  @override
  _SettingQualityPageState createState() => _SettingQualityPageState();
}

class _SettingQualityPageState extends State<SettingQualityPage>
    with TickerProviderStateMixin {
  late Widget _languageTranlator;

  final _typeList = ["follow_illust", "recom", "rank"];
  SharedPreferences? _pref;
  int _widgetTypeIndex = -1;
  GlanceIllustPersistProvider glanceIllustPersistProvider =
      GlanceIllustPersistProvider();

  @override
  void initState() {
    _buildLanguageTranlators();
    _initData();
    super.initState();
  }

  _initData() async {
    _pref = await SharedPreferences.getInstance();
    final type = await _pref?.getString("widget_illust_type") ?? "recom";
    int index = _typeList.indexOf(type);
    if (index != -1) {
      setState(() {
        _widgetTypeIndex = index;
      });
    } else {
      setState(() {
        _widgetTypeIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).quality_setting),
      ),
      body: Container(
        child: ListView(children: [
          if (Platform.isAndroid)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: ListTile(
                    trailing: Icon(Icons.keyboard_arrow_right),
                    title: Text(I18n.of(context).platform_special_setting),
                    subtitle: Text(
                      "For Android",
                      style: TextStyle(color: Colors.green),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlatformPage()));
                    },
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ListTile(
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(I18n.of(context).network),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NetworkPage(
                              automaticallyImplyLeading: true,
                            )));
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(I18n.of(context).large_preview_zoom_quality),
                    padding: EdgeInsets.all(16),
                  ),
                  Observer(builder: (_) {
                    return Container(
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorColor: Theme.of(context).colorScheme.secondary,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: [
                          Tab(
                            text: I18n.of(context).large,
                          ),
                          Tab(
                            text: I18n.of(context).source,
                          )
                        ],
                        onTap: (index) {
                          userSetting.change(index);
                        },
                        controller: TabController(
                            length: 2,
                            vsync: this,
                            initialIndex: userSetting.zoomQuality),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    child:
                        Text(I18n.of(context).illustration_detail_page_quality),
                    padding: EdgeInsets.all(16),
                  ),
                  Observer(builder: (_) {
                    return TabBar(
                      labelColor: Theme.of(context).textTheme.titleLarge!.color,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          text: I18n.of(context).medium,
                        ),
                        Tab(
                          text: I18n.of(context).large,
                        ),
                      ],
                      onTap: (index) {
                        userSetting.setPictureQuality(index);
                      },
                      controller: TabController(
                          length: 2,
                          vsync: this,
                          initialIndex: userSetting.pictureQuality),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(I18n.of(context).manga_detail_page_quality),
                    padding: EdgeInsets.all(16),
                  ),
                  Observer(builder: (_) {
                    return TabBar(
                      labelColor: Theme.of(context).textTheme.titleLarge!.color,
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: [
                        Tab(
                          text: I18n.of(context).medium,
                        ),
                        Tab(
                          text: I18n.of(context).large,
                        ),
                        Tab(
                          text: I18n.of(context).source,
                        ),
                      ],
                      onTap: (index) {
                        userSetting.setMangaQuality(index);
                      },
                      controller: TabController(
                          length: 3,
                          vsync: this,
                          initialIndex: userSetting.mangaQuality),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              children: <Widget>[
                Padding(
                  child: Row(
                    children: <Widget>[
                      Text("Language"),
                      _languageTranlator,
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  padding: EdgeInsets.all(16),
                ),
                Observer(builder: (_) {
                  var list = Languages.map(
                    (e) => Tab(text: e.language),
                  ).toList();
                  return Theme(
                    data: Theme.of(context).copyWith(
                        tabBarTheme: TabBarTheme(labelColor: Colors.black)),
                    child: TabBar(
                      labelColor: Theme.of(context).textTheme.titleLarge!.color,
                      dividerColor: Colors.transparent,
                      isScrollable: true,
                      tabs: list,
                      onTap: (index) async {
                        await userSetting.setLanguageNum(index);
                        setState(() {
                          _buildLanguageTranlators();
                        });
                      },
                      controller: TabController(
                          length: list.length,
                          vsync: this,
                          initialIndex: userSetting.languageNum),
                    ),
                  );
                })
              ],
            )),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              children: <Widget>[
                Padding(
                  child: Text(I18n.of(context).welcome_page),
                  padding: EdgeInsets.all(16),
                ),
                Observer(builder: (_) {
                  var tablist = Platform.isAndroid
                      ? [
                          Tab(
                            text: I18n.of(context).home,
                          ),
                          Tab(
                            text: I18n.of(context).rank,
                          ),
                          Tab(
                            text: I18n.of(context).quick_view,
                          ),
                          Tab(
                            text: I18n.of(context).search,
                          ),
                          Tab(
                            text: I18n.of(context).setting,
                          ),
                        ]
                      : [
                          Tab(
                            text: I18n.of(context).home,
                          ),
                          Tab(
                            text: I18n.of(context).quick_view,
                          ),
                          Tab(
                            text: I18n.of(context).search,
                          ),
                          Tab(
                            text: I18n.of(context).setting,
                          ),
                        ];
                  return Theme(
                    data: Theme.of(context).copyWith(
                        tabBarTheme: TabBarTheme(labelColor: Colors.black)),
                    child: TabBar(
                      labelColor: Theme.of(context).textTheme.headline6!.color,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: Colors.transparent,
                      tabs: tablist,
                      isScrollable: true,
                      onTap: (index) {
                        userSetting.setWelcomePageNum(index);
                      },
                      controller: TabController(
                          length: tablist.length,
                          vsync: this,
                          initialIndex: userSetting.welcomePageNum),
                    ),
                  );
                })
              ],
            )),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              children: <Widget>[
                Padding(
                  child: Text(I18n.of(context).layout_mode),
                  padding: EdgeInsets.all(16),
                ),
                Observer(builder: (_) {
                  var tablist = [
                    Tab(
                      text: "V:H",
                    ),
                    Tab(
                      text: "V:V",
                    ),
                    Tab(
                      text: "H:H",
                    ),
                  ];
                  return Theme(
                    data: Theme.of(context).copyWith(
                        tabBarTheme: TabBarTheme(labelColor: Colors.black)),
                    child: TabBar(
                      labelColor: Theme.of(context).textTheme.headline6!.color,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: Colors.transparent,
                      tabs: tablist,
                      isScrollable: true,
                      onTap: (index) {
                        userSetting.setPadMode(index);
                      },
                      controller: TabController(
                          length: tablist.length,
                          vsync: this,
                          initialIndex: userSetting.padMode),
                    ),
                  );
                })
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Text(I18n.of(context).crosscount),
                    padding: EdgeInsets.all(16),
                  ),
                  Icon(Icons.stay_primary_portrait),
                  Observer(builder: (_) {
                    return TabBar(
                      labelColor: Theme.of(context).textTheme.headline6!.color,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          text: ' 2 ',
                        ),
                        Tab(
                          text: ' 3 ',
                        ),
                        Tab(
                          text: ' 4 ',
                        ),
                        Tab(
                          text: "Adapt",
                        ),
                      ],
                      onTap: (index) async {
                        if (index == 3) {
                          await userSetting.setCrossAdapt(true);
                          Leader.push(
                              context,
                              SettingCrossAdpaterPage(
                                h: false,
                              ));
                          return;
                        }
                        await userSetting.setCrossAdapt(false);
                        await userSetting.setCrossCount(index + 2);
                        BotToast.showText(
                            text: I18n.of(context).need_to_restart_app);
                      },
                      controller: TabController(
                          length: 4,
                          vsync: this,
                          initialIndex: userSetting.crossAdapt
                              ? 3
                              : userSetting.crossCount - 2),
                    );
                  }),
                  Icon(Icons.stay_primary_landscape),
                  Observer(builder: (_) {
                    return TabBar(
                      labelColor: Theme.of(context).textTheme.headline6!.color,
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          text: ' 2 ',
                        ),
                        Tab(
                          text: ' 3 ',
                        ),
                        Tab(
                          text: ' 4 ',
                        ),
                        Tab(
                          text: "Adapt",
                        ),
                      ],
                      onTap: (index) async {
                        if (index == 3) {
                          await userSetting.setHCrossAdapt(true);
                          Leader.push(
                              context,
                              SettingCrossAdpaterPage(
                                h: true,
                              ));
                          return;
                        }
                        userSetting.setHCrossCount(index + 2);
                        BotToast.showText(
                            text: I18n.of(context).need_to_restart_app);
                      },
                      controller: TabController(
                          length: 4,
                          vsync: this,
                          initialIndex: userSetting.hCrossAdapt
                              ? 3
                              : userSetting.hCrossCount - 2),
                    );
                  }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Observer(builder: (_) {
                final targetValue = userSetting.maxRunningTask < 1
                    ? 1
                    : userSetting.maxRunningTask;
                return Column(
                  children: <Widget>[
                    Padding(
                      child: Text(
                          "${I18n.of(context).max_download_task_running_count} $targetValue"),
                      padding: EdgeInsets.all(16),
                    ),
                    Slider(
                        value: targetValue.toDouble(),
                        label: '${targetValue}',
                        min: 1,
                        max: 10,
                        divisions: 10,
                        onChanged: (v) {
                          int value = v.toInt();
                          userSetting.setMaxRunningTask(value);
                        }),
                  ],
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Observer(builder: (_) {
                return SwitchListTile(
                    value: userSetting.isBangs,
                    title: Text(I18n.of(context).special_shaped_screen),
                    subtitle: Text('--v--'),
                    onChanged: (value) async {
                      userSetting.setIsBangs(value);
                    });
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Observer(builder: (_) {
                return SwitchListTile(
                    value: userSetting.longPressSaveConfirm,
                    title: Text(I18n.of(context).long_press_save_confirm),
                    onChanged: (value) async {
                      userSetting.setLongPressSaveConfirm(value);
                    });
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Observer(builder: (_) {
                return SwitchListTile(
                    value: userSetting.hIsNotAllow,
                    title: Text('H是不行的！'),
                    onChanged: (value) async {
                      if (!value) BotToast.showText(text: 'H是可以的！(ˉ﹃ˉ)');
                      userSetting.setHIsNotAllow(value);
                    });
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Observer(builder: (_) {
                return SwitchListTile(
                    value: userSetting.isReturnAgainToExit,
                    title: Text(I18n.of(context).return_again_to_exit),
                    onChanged: (value) async {
                      userSetting.setIsReturnAgainToExit(value);
                    });
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Observer(builder: (_) {
                return SwitchListTile(
                    value: userSetting.swipeChangeArtwork,
                    title: Text(I18n.of(context).swipe_to_switch_artworks),
                    onChanged: (value) async {
                      userSetting.setSwipeChangeArtwork(value);
                    });
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Observer(builder: (_) {
                return SwitchListTile(
                    value: userSetting.followAfterStar,
                    title: Text(I18n.of(context).follow_after_star),
                    onChanged: (value) async {
                      userSetting.setFollowAfterStar(value);
                    });
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Observer(builder: (_) {
                return SwitchListTile(
                    value: userSetting.defaultPrivateLike,
                    title: Text(I18n.of(context).private_like_by_default),
                    onChanged: (value) async {
                      userSetting.setDefaultPrivateLike(value);
                    });
              }),
            ),
          ),
          if (Platform.isIOS)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Observer(builder: (_) {
                  return SwitchListTile(
                      value: userSetting.nsfwMask,
                      title: Text("最近任务遮罩"),
                      onChanged: (value) async {
                        userSetting.changeNsfwMask(value);
                      });
                }),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Observer(
                  builder: (context) {
                    return ListTile(
                      onTap: () {
                        Leader.push(context, CopyTextPage());
                      },
                      title: Text(I18n.of(context).share_info_format),
                      trailing: Icon(Icons.arrow_forward),
                    );
                  },
                ),
              ),
            ),
          ),
          if (_widgetTypeIndex != -1)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                  child: Column(
                children: <Widget>[
                  Padding(
                    child: Text("App widget type"),
                    padding: EdgeInsets.all(16),
                  ),
                  Observer(builder: (_) {
                    var tablist = [
                      Tab(
                        text: I18n.of(context).recommend,
                      ),
                      Tab(
                        text: I18n.of(context).rank,
                      ),
                      Tab(
                        text: I18n.of(context).news,
                      ),
                    ];
                    return Theme(
                      data: Theme.of(context).copyWith(
                          tabBarTheme: TabBarTheme(labelColor: Colors.black)),
                      child: TabBar(
                        labelColor:
                            Theme.of(context).textTheme.headline6!.color,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: tablist,
                        isScrollable: true,
                        onTap: (index) async {
                          try {
                            final type = _typeList[index];
                            await _pref?.setString("widget_illust_type", type);
                            await glanceIllustPersistProvider.open();
                            await glanceIllustPersistProvider.deleteAll();
                          } catch (e) {}
                        },
                        controller: TabController(
                            length: tablist.length,
                            vsync: this,
                            initialIndex: _widgetTypeIndex),
                      ),
                    );
                  })
                ],
              )),
            ),
        ]),
      ),
    );
  }

  void _buildLanguageTranlators() {
    final langsponsors =
        Languages[userSetting.languageNum].sponsors;
    _languageTranlator = Row(
      children: [
        for (final langsponsor in langsponsors)
          InkWell(
            onTap: () {
              try {
                if (Platform.isAndroid && !Constants.isGooglePlay)
                  launchUrl(Uri.dataFromString(langsponsor.uri));
              } catch (e) {}
            },
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(langsponsor.avatar),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(langsponsor.name),
                ),
                if (langsponsor == langsponsors.last) Icon(Icons.translate)
              ],
            ),
          ),
      ],
    );
  }
}
