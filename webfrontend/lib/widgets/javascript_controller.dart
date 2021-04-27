@JS()
library blockchainlogic.js;

import 'package:js/js.dart';
//import 'dart:js_util';

@JS()
external dynamic login();
external dynamic loggedIn();
external dynamic logout();
external dynamic createNewNFT(var _file, String _name, String _description);
external dynamic startNewAuction(String _tokenId, String _duration);
external dynamic bidForNFT(String _tokenId, String _bid, String _uid);
external dynamic sellNFT(String _tokenId, String _price);
external dynamic removeAuction(String _tokenId);
external dynamic startNewOffer(String _tokenId, String _price);
external dynamic removeOffer(String _tokenId);
external dynamic buy(String _tokenId, String _price);
external dynamic getUserItems();
external dynamic getItemsForSale();
external dynamic getItemsForAuction();
external dynamic getAuctionItem(String _tokenId);
external dynamic getOfferItem(String _tokenId);
external dynamic getMyBids();
