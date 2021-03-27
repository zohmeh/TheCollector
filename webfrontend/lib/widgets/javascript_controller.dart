@JS()
library blockchainlogic.js;

import 'package:js/js.dart';
//import 'dart:js_util';

@JS()
external dynamic login();
external dynamic loggedIn();
external dynamic logout();
external dynamic setMeme(String _memeHash);
external dynamic getMeme();
external dynamic createNewNFT(var _file, String _name, String _description);
external dynamic getMyTokens();
