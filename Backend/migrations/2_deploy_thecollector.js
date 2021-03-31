const TheCollector = artifacts.require("TheCollector");

module.exports = function (deployer) {
  deployer.deploy(TheCollector);
};