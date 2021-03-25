import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';
import '../routing/route_names.dart';
import '../services/navigation_service.dart';
import '../locator.dart';
import '../widgets/button.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ScrollController _scrollController = ScrollController();

  _changeSide(List _arguments) {
    locator<NavigationService>().navigateTo(_arguments[0], queryParams: {
      "id": _arguments[1].toString(),
      "param": _arguments[2].toString()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 150,
      child: VsScrollbar(
        controller: _scrollController,
        showTrackOnHover: true,
        isAlwaysShown: false,
        scrollbarFadeDuration: Duration(milliseconds: 500),
        scrollbarTimeToFade: Duration(milliseconds: 800),
        style: VsScrollbarStyle(
          hoverThickness: 10.0,
          radius: Radius.circular(10),
          thickness: 10.0,
          color: Theme.of(context).highlightColor,
        ),
        child: GridView.builder(
          controller: _scrollController,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: 20,
              mainAxisSpacing: 30,
              mainAxisExtent: 200,
              maxCrossAxisExtent: 200),
          itemCount: 100,
          itemBuilder: (ctx, idx) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.photo),
                  button(
                      Theme.of(context).buttonColor,
                      Theme.of(context).highlightColor,
                      'Button ${idx}',
                      _changeSide,
                      [ButtonListRoute, idx, 42])
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
