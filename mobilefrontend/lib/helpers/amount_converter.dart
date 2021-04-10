String amountConverter(BigInt _amount) {
  final eth = _amount.toDouble() / 1000000000000000000;
  return (eth.toStringAsFixed(2));
}

tokenAmountConverter(double _amount) {
  return _amount * 1000000000000000000;
}
