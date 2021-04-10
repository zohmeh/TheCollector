import '../helpers/addresses.dart';
import '../providers/blockchain_interaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:web_socket_channel/io.dart';
import '../helpers/configuration_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import '../helpers/hd_key.dart';
import "package:hex/hex.dart";
import 'package:web3dart/credentials.dart';

class BlockchainWalletInteraction with ChangeNotifier {
  IConfigurationService _configService;

  //Defining all variables
  String abiCode;
  EthereumAddress contractAddress;
  DeployedContract erc20Contract;
  DeployedContract erc1155Contract;

  Credentials credentials;
  EthereumAddress ownAddress;
  String privateKey = "";

  //Generating and Importing an Ethereum Account
  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  String entropyToMnemonic(String entropyMnemonic) {
    return bip39.entropyToMnemonic(entropyMnemonic);
  }

  String setPrivateKey(String mnemonic) {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    KeyData master = HDKey.getMasterKeyFromSeed(seed);
    privateKey = HEX.encode(master.key);
    return privateKey;
  }

  Future<double> getMyBalance() async {
    await creatingCredentials();
    EtherAmount myBalance = await ethClient.getBalance(ownAddress);
    return (myBalance.getValueInUnit(EtherUnit.ether).toDouble());
  }

  Future<String> getPrivateKey1() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("privateKey");
  }

  String getPrivateKey(String mnemonic) {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    KeyData master = HDKey.getMasterKeyFromSeed(seed);
    privateKey = HEX.encode(master.key);
    return privateKey;
  }

  Future<EthereumAddress> getPublicAddress(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);

    final address = await private.extractAddress();
    return address;
  }

  Future<bool> setupFromMnemonic(String mnemonic) async {
    final cryptMnemonic = bip39.mnemonicToEntropy(mnemonic);
    privateKey = this.getPrivateKey(cryptMnemonic);

    await _configService.setMnemonic(cryptMnemonic);
    await _configService.setPrivateKey(privateKey);
    await _configService.setupDone(true);
    return true;
  }

  Future<bool> setupFromPrivateKey(String privateKey) async {
    await _configService.setMnemonic(null);
    await _configService.setPrivateKey(privateKey);
    await _configService.setupDone(true);
    return true;
  }

  //Network for the Blockchain
  static String rpcUrl =
      "https://ropsten.infura.io/v3/134eb24f9b9d410baa2acac76d2a7be3";
  //static String wsUrl =
  //    "wss://kovan.infura.io/ws/v3/134eb24f9b9d410baa2acac76d2a7be3";
  //static String rpcUrl = "HTTP://192.168.178.20:7545";
  Web3Client ethClient = Web3Client(rpcUrl, http.Client());

  //Generating web3 Client
  //Web3Client ethClient = Web3Client(rpcUrl, http.Client(), socketConnector: () {
  //  return IOWebSocketChannel.connect(wsUrl).cast<String>();
  //});

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

  Future<EthereumAddress> getMyOwnAddress() async {
    await creatingCredentials();
    return ownAddress;
  }
}
