//import 'dart:convert';
//import 'dart:typed_data';
import '../helpers/addresses.dart';
import '../helpers/amount_converter.dart';
import 'package:flutter/cupertino.dart';
//import 'package:hex/hex.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:uuid/uuid.dart';
//import 'package:better_uuid/uuid.dart';
//import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/credentials.dart';

class BlockchainInteraction with ChangeNotifier {
  //Defining all variables
  String abiCode;
  EthereumAddress nfttokencontractaddress;
  DeployedContract nfttokencontract;
  EthereumAddress marketplacecontractaddress;
  DeployedContract marketplacecontract;
  Credentials credentials;
  EthereumAddress ownAddress;

  //Network for the Blockchain
  static String rpcUrl =
      "https://ropsten.infura.io/v3/134eb24f9b9d410baa2acac76d2a7be3";
  //static String wsUrl =
  //    "wss://kovan.infura.io/ws/v3/134eb24f9b9d410baa2acac76d2a7be3";
  //static String rpcUrl = "HTTP://192.168.178.20:7545";
  //static String rpcUrl = "HTTP://127.0.0.1:7545";

  //Generating web3 Client
  Web3Client ethClient =
      Web3Client(rpcUrl, http.Client()); //, socketConnector: () {
  //return IOWebSocketChannel.connect(wsUrl).cast<String>();
  //});

  //Loading deployed Contract
  Future<void> loadContractNFTTokenContract() async {
    abiCode = await rootBundle.loadString("assets/abi/TheCollectorNFTABI.json");
    nfttokencontractaddress = EthereumAddress.fromHex(Addresses().nftToken);
    nfttokencontract = DeployedContract(
        ContractAbi.fromJson(abiCode, "TheCollectorNFTABI"),
        nfttokencontractaddress);
  }

  Future<void> loadContractMarketplaceContract() async {
    abiCode = await rootBundle.loadString("assets/abi/MarketplaceABI.json");
    marketplacecontractaddress =
        EthereumAddress.fromHex(Addresses().marketplace);
    marketplacecontract = DeployedContract(
        ContractAbi.fromJson(abiCode, "MarketplaceABI"),
        marketplacecontractaddress);
  }

  //Creating Credentials for signing transactions
  Future<void> creatingCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final privateKey = prefs.getString("privateKey");
    if (privateKey != "") {
      credentials = await ethClient.credentialsFromPrivateKey(privateKey);
      ownAddress = await credentials.extractAddress();
    } else {
      return;
    }
  }

  Future getMyTokens() async {
    await loadContractNFTTokenContract();
    await creatingCredentials();
    List tokenIds = [];
    List tokenHashes = [];
    Map<dynamic, dynamic> returnValues;

    //Lists all Balances
    List balance = await ethClient.call(
        sender: ownAddress,
        contract: nfttokencontract,
        function: nfttokencontract.function("balanceOf"),
        params: [ownAddress]);

    for (var i = 0; i < int.parse(balance[0].toString()); i++) {
      var tokenId = await ethClient.call(
          sender: ownAddress,
          contract: nfttokencontract,
          function: nfttokencontract.function("tokenOfOwnerByIndex"),
          params: [ownAddress, BigInt.from(i)]);
      tokenIds.add(tokenId[0]);
    }

    for (var i = 0; i < tokenIds.length; i++) {
      var tokenHash = await ethClient.call(
          sender: ownAddress,
          contract: nfttokencontract,
          function: nfttokencontract.function("getTokenhash"),
          params: [tokenIds[i]]);
      tokenHashes.add(tokenHash[0]);
    }
    returnValues = {1: tokenIds, 2: tokenHashes};
    return returnValues;
  }

  Future getAuctionData(String _tokenId) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var auctionData = await ethClient.call(
        sender: ownAddress,
        contract: marketplacecontract,
        function: marketplacecontract.function("getAuctionData"),
        params: [BigInt.from(int.parse(_tokenId))]);
    return auctionData;
  }

  Future getOfferData(String _tokenId) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var offerData = await ethClient.call(
        sender: ownAddress,
        contract: marketplacecontract,
        function: marketplacecontract.function("getOfferData"),
        params: [BigInt.from(int.parse(_tokenId))]);
    return offerData;
  }
}
