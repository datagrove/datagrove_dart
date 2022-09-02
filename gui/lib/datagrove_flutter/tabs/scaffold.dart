import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../client/datagrove_flutter.dart';
import 'package:path/path.dart' as p;

import '../client/identity.dart';
import 'notify.dart';
import 'contact.dart';
import 'nav.dart';
import 'profile.dart';
import 'starred.dart';

// base32 only uses 2-7, can we use 0 in clever way? issue is that whatever we do we need to explain why you can't use a url to user, and the less likely the trap, the more painful when they fall in.

// urls look like host/{group-app-sponsor}/{publication id or query}?parameters
// note is exactly one publication; to query more, we query on publication reference in that publication.

// maybe this should cross to the isolate? it will be hard to keep cache
// up to date here. could be laggy to contact isolate every time though.

// resolving everything about the route may be

// th
makeRouter(Dgf dgf) {
  return UrlRouter(
    onGeneratePages: (router) {
      return [
        CupertinoPage(child: TabScaffold())
        //MaterialPage(child: Text(router.url)),
      ];
    },
  );
}

class DgApp extends StatelessWidget {
  Dgf fl;
  DgApp(this.fl);

  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness =
        WidgetsBinding.instance.window.platformBrightness;
    return ChangeNotifierProvider<Dgf>(
        create: (_) => fl,
        child: Theme(
            data: ThemeData(
                brightness: platformBrightness,
                scaffoldBackgroundColor: CupertinoColors.black),
            child: CupertinoApp.router(
              theme: const CupertinoThemeData(brightness: Brightness.dark),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('es', ''),
                Locale('fr', 'CA'),
              ],
              routerDelegate: makeRouter(fl),
              //     RoutemasterDelegate(routesBuilder: (context) => routes),
              routeInformationParser: UrlRouteParser(),

              title: "Datagrove",
              debugShowCheckedModeBanner: false,
            )));
  }
}

// this needs a router, and global keys for its delegates
class TabScaffold extends StatefulWidget {
  TabScaffold({
    Key? key,
  }) : super(key: key) {}

  @override
  State<TabScaffold> createState() => TabScaffoldState();
}

// override each tab, but allow a default?
// the primary thing we need is a database widget that supports add/edit/delete

// it's not clear if this should just be a tree, or if we should try to reign it a little  to avoid getting too deep. But we need something that registers all the things an app can set. a registry editor, yaml editor, etc. Maybe guided by tree style schemas instead of relational since the data is sparse and deep.

class TabScaffoldState extends State<TabScaffold> {
  int _selectedIndex = 0;

  final tab = [
    NavTab(
        key: UniqueKey(),
        icon: Icon(CupertinoIcons.tree),
        label: 'Grove',
        child: HomeTab()),
    NavTab(
        key: UniqueKey(),
        icon: Icon(CupertinoIcons.bell),
        label: 'Notify',
        child: AlertTab()),
    NavTab(
        key: UniqueKey(),
        icon: Icon(CupertinoIcons.star),
        label: 'Starred',
        child: StarredTab()),
    NavTab(
        key: UniqueKey(),
        icon: Icon(Icons.mail),
        label: 'Messages',
        child: MessageTab()),
    NavTab(
      key: UniqueKey(),
      icon: Icon(Icons.settings),
      label: 'Profile',
      child: ProfileTab(),
    )
  ];

  @override
  didUpdateWidget(TabScaffold old) {
    super.didUpdateWidget(old);
  }

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 700;
    final dg = Dgf.of(context);
    // this needs to change to a different list
    if (dg.unlinked) {
      return OnboardDesktop();
    }

    return Material(
        child: Scaffold(
            bottomNavigationBar: wide
                ? null
                : BottomNavigationBar(
                    backgroundColor: CupertinoColors.darkBackgroundGray,
                    unselectedItemColor: CupertinoColors.inactiveGray,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        // this isn't correct, we need to set whatever url
                        // is current for that navigator.
                        // context.url =
                        //     <String>["/g", "/n", "/s", "/m", "/p"][index];
                      });
                    },
                    items: [
                        for (var o in tab)
                          BottomNavigationBarItem(icon: o.icon, label: o.label)
                      ]),
            // we need to keep the navigation rail alive, and fade it out.
            body: Row(children: <Widget>[
              if (wide)
                NavigationRail(
                  backgroundColor: CupertinoColors.darkBackgroundGray,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      // context.url =
                      //     <String>["/g", "/n", "/s", "/m", "/p"][index];
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: [
                    for (var o in tab)
                      NavigationRailDestination(
                        icon: o.icon,
                        selectedIcon: o.icon,
                        //selectedIcon: o.activeIcon,
                        label: Text(o.label),
                      )
                  ],
                ),
              if (wide) const VerticalDivider(thickness: 1, width: 1),

              // This is the main content.
              Expanded(
                  child: IndexedStack(
                      index: _selectedIndex, children: [for (var o in tab) o]))
            ])));
  }
}

// database > views > pickers
// maintain position
//

abstract class PageStacker {
  push(Widget w);
  pop();
}
