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
  EthereumAddress contractAddress;
  DeployedContract contract;
  DeployedContract contractCT;
  DeployedContract erc20Contract;
  Credentials credentials;
  EthereumAddress ownAddress;

  //Network for the Blockchain
  //static String rpcUrl =
  //    "https://kovan.infura.io/v3/134eb24f9b9d410baa2acac76d2a7be3";
  //static String wsUrl =
  //    "wss://kovan.infura.io/ws/v3/134eb24f9b9d410baa2acac76d2a7be3";
  static String rpcUrl = "HTTP://192.168.178.20:7545";

  //Generating web3 Client
  Web3Client ethClient =
      Web3Client(rpcUrl, http.Client()); //, socketConnector: () {
  //return IOWebSocketChannel.connect(wsUrl).cast<String>();
  //});

  //Loading deployed Contract
  Future<void> loadContractDushiCustomerBets() async {
    abiCode =
        await rootBundle.loadString("assets/abi/DushiCustomerBetsABI.json");
    contractAddress = EthereumAddress.fromHex(Addresses().dushiCustomerBet);
    contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "BettingDapp"), contractAddress);
  }

  //Loading deployed Contract
  Future<void> loadContractCT() async {
    abiCode =
        await rootBundle.loadString("assets/abi/ConditionalTokenABI.json");
    contractAddress = EthereumAddress.fromHex(Addresses().conditionalToken);
    contractCT = DeployedContract(
        ContractAbi.fromJson(abiCode, "ConditionalToken"), contractAddress);
  }

  Future<void> loadContractErc20() async {
    abiCode = await rootBundle.loadString("assets/abi/ERC20ABI.json");
    contractAddress = EthereumAddress.fromHex(Addresses().toyToken);
    erc20Contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "ERC20"), contractAddress);
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

  Future<List> getBet(String _betId) async {
    await loadContractDushiCustomerBets();
    await creatingCredentials();
    List bet = await ethClient.call(
        sender: ownAddress,
        contract: contract,
        function: contract.function("getBet"),
        params: [BigInt.from(int.parse(_betId))]);
    return bet[0];
  }

  Future<List> getZero() async {
    await loadContractDushiCustomerBets();
    await creatingCredentials();
    List zero = await ethClient.call(
        sender: ownAddress,
        contract: contract,
        function: contract.function("getZero"),
        params: []);
    return zero[0];
  }

  Future<List> getMyPositionId(String _betId) async {
    await loadContractDushiCustomerBets();
    await creatingCredentials();
    List myPositionIds = await ethClient.call(
        sender: ownAddress,
        contract: contract,
        function: contract.function("getMyPositionIds"),
        params: [BigInt.from(int.parse(_betId))]);
    return myPositionIds[0];
  }

  Future<List> getMyBetIds() async {
    await loadContractDushiCustomerBets();
    await creatingCredentials();
    List myBetIds = await ethClient.call(
        sender: ownAddress,
        contract: contract,
        function: contract.function("getMyBetIds"),
        params: []);
    return myBetIds[0];
  }

  Future<String> approveERC20(String _address, double _amount) async {
    await loadContractErc20();
    await creatingCredentials();
    String hash = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: erc20Contract,
          function: erc20Contract.function("approve"),
          parameters: [
            EthereumAddress.fromHex(_address),
            BigInt.from(tokenAmountConverter(_amount)),
          ],
          from: ownAddress,
          maxGas: TransactionSettings().gasLimit,
          gasPrice: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, TransactionSettings().gasPrice),
        ),
        chainId: 42);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(hash))
        .where((receipt) => receipt != null)
        .first;
    return hash;
  }

  Future<String> createBet(
      String id, int _outComeSlotCount, List<dynamic> _partitionArray) async {
    print(id);
    print(_outComeSlotCount);
    print(_partitionArray);

    await loadContractDushiCustomerBets();
    await creatingCredentials();
    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function("createNewBet"),
        parameters: [
          BigInt.from(int.parse(id)),
          BigInt.from(_outComeSlotCount),
          _partitionArray,
        ],
        from: ownAddress,
        maxGas: TransactionSettings().gasLimit,
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, TransactionSettings().gasPrice),
      ),
    ); //chainId: 42);
    //TransactionReceipt txReceipt = await ethClient
    //    .addedBlocks()
    //    .asyncMap((_) => ethClient.getTransactionReceipt(hash))
    //    .where((receipt) => receipt != null)
    //    .first;
    //print(txReceipt.status);
    //print(txReceipt.transactionHash);
    //return txReceipt.status;
    return hash;
  }

  Future<String> fundBet(String id, double _amount) async {
    print(id);
    print(_amount);

    await loadContractDushiCustomerBets();
    await creatingCredentials();
    await approveERC20(Addresses().dushiCustomerBet, _amount);
    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function("addLiquidity"),
        parameters: [
          BigInt.from(int.parse(id)),
          BigInt.from(tokenAmountConverter(_amount))
        ],
        from: ownAddress,
        maxGas: TransactionSettings().gasLimit,
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, TransactionSettings().gasPrice),
      ),
    ); //chainId: 42);
    //TransactionReceipt txReceipt = await ethClient
    //    .addedBlocks()
    //    .asyncMap((_) => ethClient.getTransactionReceipt(hash))
    //    .where((receipt) => receipt != null)
    //    .first;
    //print(txReceipt.status);
    //print(txReceipt.transactionHash);
    //return txReceipt.status;
    return hash;
  }

  Future<String> joinBet(String _betId, double _amount, int _bettingTip) async {
    await loadContractDushiCustomerBets();
    await creatingCredentials();
    await approveERC20(Addresses().dushiCustomerBet, _amount);

    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function("placeBet"),
        parameters: [
          BigInt.from(int.parse(_betId)),
          BigInt.from(tokenAmountConverter(_amount)),
          BigInt.from(_bettingTip),
        ],
        from: ownAddress,
        maxGas: TransactionSettings().gasLimit,
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, TransactionSettings().gasPrice),
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

  Future<String> removeLiquidity(String _betId) async {
    await loadContractDushiCustomerBets();
    await creatingCredentials();
    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function("removeLiquidity"),
        parameters: [BigInt.from(int.parse(_betId))],
        from: ownAddress,
        maxGas: TransactionSettings().gasLimit,
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, TransactionSettings().gasPrice),
      ),
    ); //chainId: 42);
    TransactionReceipt txReceipt = await ethClient
        .addedBlocks()
        .asyncMap((_) => ethClient.getTransactionReceipt(hash))
        .where((receipt) => receipt != null)
        .first;
    //return txReceipt.status;
    return hash;
  }

  Future<String> requestBetResult(String _betId, List<dynamic> _result) async {
    await loadContractDushiCustomerBets();
    await creatingCredentials();
    await removeLiquidity(_betId);

    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function("resultRequest"),
        parameters: [BigInt.from(int.parse(_betId)), _result],
        from: ownAddress,
        maxGas: TransactionSettings().gasLimit,
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, TransactionSettings().gasPrice),
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

  Future<String> approveResult(String _betId) async {
    await loadContractDushiCustomerBets();
    await creatingCredentials();

    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function("approveResult"),
        parameters: [BigInt.from(int.parse(_betId))],
        from: ownAddress,
        maxGas: TransactionSettings().gasLimit,
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, TransactionSettings().gasPrice),
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

  //Withdraw my profit
  Future<String> redeemBet(String _betId) async {
    await loadContractCT();
    await creatingCredentials();
    List<dynamic> zero = await getZero();
    List<dynamic> bet = await getBet(_betId);

    String hash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contractCT,
        function: contractCT.function("redeemPositions"),
        parameters: [
          EthereumAddress.fromHex(Addresses().toyToken),
          zero,
          bet[3],
          bet[8]
        ],
        maxGas: TransactionSettings().gasLimit,
        gasPrice: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, TransactionSettings().gasPrice),
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
}
