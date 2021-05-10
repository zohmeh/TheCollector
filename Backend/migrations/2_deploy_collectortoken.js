const CollectorToken = artifacts.require("CollectorToken");

module.exports = async function (deployer) {
  await deployer.deploy(CollectorToken);
  contractInstance = await CollectorToken.deployed();
  await contractInstance.mintToken("0x5Be4da58813F8D38862521dd3bA8BDCfD97C1Ca0", "100000000000000000000000");
}