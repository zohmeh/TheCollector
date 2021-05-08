import 'package:flutter/material.dart';
import '../settingsview/accountsettingsmobielview.dart';
import '../settingsview/accountsettingsdesktopview.dart';
import '../../responsive.dart';

class AccountSettingsView extends StatefulWidget {
  @override
  _AccountSettingsViewState createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: AccountSettingsMobileView(),
        tablet: AccountSettingsMobileView(),
        desktop: AccountSettingsDesktopView());
  }
}
