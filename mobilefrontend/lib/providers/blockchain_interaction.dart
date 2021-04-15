import 'package:web_socket_channel/io.dart';
import '../helpers/addresses.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  //    "wss://ropsten.infura.io/v3/134eb24f9b9d410baa2acac76d2a7be3";
  //static String rpcUrl = "HTTP://192.168.178.20:7545";
  //static String rpcUrl = "HTTP://127.0.0.1:7545";

  //Generating web3 Client
  Web3Client ethClient =
      Web3Client(rpcUrl, http.Client()); //, socketConnector: () {
  //  return IOWebSocketChannel.connect(wsUrl).cast<String>();
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

  Future getTokenHash(String _tokenId) async {
    await loadContractNFTTokenContract();
    await creatingCredentials();
    var tokenhash = await ethClient.call(
        sender: ownAddress,
        contract: nfttokencontract,
        function: nfttokencontract.function("getTokenhash"),
        params: [BigInt.from(int.parse(_tokenId))]);
    return tokenhash[0];
  }

  Future getallAuctions() async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var allauctions = await ethClient.call(
        sender: ownAddress,
        contract: marketplacecontract,
        function: marketplacecontract.function("getAllActiveAuctions"),
        params: []);
    return allauctions[0];
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

  Future getAllOffers() async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var alloffers = await ethClient.call(
        sender: ownAddress,
        contract: marketplacecontract,
        function: marketplacecontract.function("getAllActiveOffers"),
        params: []);
    return alloffers[0];
  }

  Future<String> _approveNFT() async {
    await loadContractNFTTokenContract();
    await creatingCredentials();
    var approve = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: nfttokencontract,
          function: nfttokencontract.function("setApprovalForAll"),
          parameters: [EthereumAddress.fromHex(Addresses().marketplace), true],
          from: ownAddress,
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 3);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(approve))
        .where((receipt) => receipt != null)
        .first;
    return approve;
  }

  Future startAuction(String _tokenId, String _duration) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    //Approve Marketplace to use my NFT
    var approve = await _approveNFT();
    var auction = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: marketplacecontract,
          function: marketplacecontract.function("startAuction"),
          parameters: [
            BigInt.from(int.parse(_tokenId)),
            BigInt.from(int.parse(_duration))
          ],
          from: ownAddress,
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 3);
    //TransactionReceipt txReceipt = await ethClient
    //    .addedBlocks()
    //    .asyncMap((_) => ethClient.getTransactionReceipt(auction))
    //    .where((receipt) => receipt != null)
    //    .first;
    //print(txReceipt);
    //return txReceipt.status;
    return auction;
  }

  Future removeAuction(String _tokenId) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var removeauction = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: marketplacecontract,
          function: marketplacecontract.function("deleteAuction"),
          parameters: [BigInt.from(int.parse(_tokenId))],
          from: ownAddress,
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 3);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(removeauction))
        .where((receipt) => receipt != null)
        .first;
    print(txReceipt);
    //return txReceipt.status;
    return removeauction;
  }

  Future startOffer(String _tokenId, String _price) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    //Approve Marketplace to use my NFT
    var approve = await _approveNFT();
    var offer = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: marketplacecontract,
          function: marketplacecontract.function("setOffer"),
          parameters: [
            BigInt.from(int.parse(_tokenId)),
            BigInt.from(int.parse(_price))
          ],
          from: ownAddress,
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 3);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(offer))
        .where((receipt) => receipt != null)
        .first;
    print(txReceipt);
    //return txReceipt.status;
    return offer;
  }

  Future removeOffer(String _tokenId) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var removeoffer = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: marketplacecontract,
          function: marketplacecontract.function("removeOffer"),
          parameters: [BigInt.from(int.parse(_tokenId))],
          from: ownAddress,
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 3);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(removeoffer))
        .where((receipt) => receipt != null)
        .first;
    print(txReceipt);
    //return txReceipt.status;
    return removeoffer;
  }

  Future bidForNFT(String _tokenId, String _bid) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var bid = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: marketplacecontract,
          function: marketplacecontract.function("bid"),
          parameters: [
            BigInt.from(int.parse(_tokenId)),
            BigInt.from(int.parse(_bid))
          ],
          from: ownAddress,
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 3);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(bid))
        .where((receipt) => receipt != null)
        .first;
    print(txReceipt);
    //return txReceipt.status;
    return bid;
  }

  Future sellNFT(String _tokenId, String _bid) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var sell = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: marketplacecontract,
          function: marketplacecontract.function("sellItem"),
          parameters: [
            BigInt.from(int.parse(_tokenId)),
          ],
          from: ownAddress,
          value: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, BigInt.from(int.parse(_bid))),
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 3);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(sell))
        .where((receipt) => receipt != null)
        .first;
    print(txReceipt);
    //return txReceipt.status;
    return sell;
  }

  Future buyNFT(String _tokenId, String _price) async {
    await loadContractMarketplaceContract();
    await creatingCredentials();
    var buy = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: marketplacecontract,
          function: marketplacecontract.function("buyNFT"),
          parameters: [
            BigInt.from(int.parse(_tokenId)),
          ],
          from: ownAddress,
          value: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, BigInt.from(int.parse(_price))),
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 3);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(buy))
        .where((receipt) => receipt != null)
        .first;
    print(txReceipt);
    //return txReceipt.status;
    return buy;
  }
}
