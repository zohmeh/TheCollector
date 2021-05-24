const CollectorToken = artifacts.require("CollectorToken");

module.exports = async function (deployer) {
  await deployer.deploy(CollectorToken);
  contractInstance = await CollectorToken.deployed();
  await contractInstance.mintToken("0xE64b4C679F285C2bED00155ca0f5cf20de844298", "100000000000000000000000");
}