const Marketplace = artifacts.require("Marketplace");
const TheCollector = artifacts.require("TheCollector")

module.exports = function (deployer) {
  deployer.deploy(Marketplace, TheCollector.address);
};