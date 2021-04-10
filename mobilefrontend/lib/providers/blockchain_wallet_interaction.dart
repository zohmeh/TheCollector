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
  //static String rpcUrl =
  //    "https://kovan.infura.io/v3/134eb24f9b9d410baa2acac76d2a7be3";
  //static String wsUrl =
  //    "wss://kovan.infura.io/ws/v3/134eb24f9b9d410baa2acac76d2a7be3";
  static String rpcUrl = "HTTP://192.168.178.20:7545";
  Web3Client ethClient = Web3Client(rpcUrl, http.Client());

  //Generating web3 Client
  //Web3Client ethClient = Web3Client(rpcUrl, http.Client(), socketConnector: () {
  //  return IOWebSocketChannel.connect(wsUrl).cast<String>();
  //});

  //Loading deployed Contract
  Future<void> loadContractERC20() async {
    abiCode = await rootBundle.loadString("assets/abi/ERC20ABI.json");
    contractAddress = EthereumAddress.fromHex(Addresses().toyToken);
    erc20Contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "ERC20"), contractAddress);
  }

//Loading deployed Contract
  Future<void> loadContractERC1155() async {
    abiCode = await rootBundle.loadString("assets/abi/ERC1155ABI.json");
    contractAddress = EthereumAddress.fromHex(Addresses().conditionalToken);
    erc1155Contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "ERC1155"), contractAddress);
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

  Future<List> erc1155TokenBalance() async {
    await loadContractERC1155();
    await creatingCredentials();
    List myBets = new List();
    List myBetIds = await BlockchainInteraction().getMyBetIds();

    for (int i = 0; i < myBetIds.length; i++) {
      List myPositionIds =
          await BlockchainInteraction().getMyPositionId(myBetIds[i].toString());
      //Als Parameter für "balanceOfBatch" müssen die beiden Arrays für Address und PositionId die selbe Länge haben
      List addressArray = new List(myPositionIds.length);
      for (int j = 0; j < myPositionIds.length; j++) {
        addressArray[j] = ownAddress;
      }
      List balanceCT = await ethClient.call(
          sender: ownAddress,
          contract: erc1155Contract,
          function: erc1155Contract.function("balanceOfBatch"),
          params: [addressArray, myPositionIds]);
      myBets.add({myBetIds[i]: balanceCT[0]});
    }
    return (myBets);
  }

  Future<List> tokenBalance() async {
    await loadContractERC20();
    await creatingCredentials();
    List balance = await ethClient.call(
        sender: ownAddress,
        contract: erc20Contract,
        function: erc20Contract.function("balanceOf"),
        params: [ownAddress]);
    return balance;
  }

  //Sending Tokens from one user to another
  Future<String> sendTokens(String _receiver, double _amount) async {
    await loadContractERC20();
    await creatingCredentials();
    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: erc20Contract,
        function: erc20Contract.function("transfer"),
        parameters: [
          EthereumAddress.fromHex(_receiver),
          BigInt.from(_amount),
        ],
        from: ownAddress,
        maxGas: TransactionSettings().gasLimit,
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.gwei, TransactionSettings().gasPrice),
      ),
    ); //chainId: 42);
    //TransactionReceipt txReceipt = await ethClient
    //    .addedBlocks()
    //    .asyncMap((_) => ethClient.getTransactionReceipt(hash))
    //    .where((receipt) => receipt != null)
    //    .first;
    //return txReceipt.status;
    return hash;
  }

  //Sending Funds from one user to another
  Future<String> sendFunds(String _receiver, double _amount) async {
    await creatingCredentials();
    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction(
          to: EthereumAddress.fromHex(_receiver),
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.gwei, TransactionSettings().gasPrice),
          value: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, BigInt.from(_amount))),
    ); //chainId: 42);
    //TransactionReceipt txReceipt = await ethClient
    //    .addedBlocks()
    //    .asyncMap((_) => ethClient.getTransactionReceipt(hash))
    //    .where((receipt) => receipt != null)
    //    .first;
    //return txReceipt.status;
    return hash;
  }

  Future<EthereumAddress> getMyOwnAddress() async {
    await creatingCredentials();
    return ownAddress;
  }
}
