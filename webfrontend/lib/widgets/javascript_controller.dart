@JS()
library blockchainlogic.js;

import 'package:js/js.dart';
//import 'dart:js_util';

@JS()
external dynamic login();
external dynamic loggedIn();
external dynamic logout();
external dynamic createNewNFT(var _file, String _name, String _description);
external dynamic getMyTokens();
external dynamic getAuctionTokens();
external dynamic startNewAuction(String _tokenId, String _duration);
external dynamic getAuctionData(String _tokenId);
external dynamic getTokenHash(String _tokenId);
external dynamic bidForNFT(String _tokenId, String _bid);
external dynamic getBackNFT(String _tokenId);
external dynamic sellNFT(String _tokenId, String _price);
