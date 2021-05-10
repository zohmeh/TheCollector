const TheCollector = artifacts.require("TheCollector");
const Reward = artifacts.require("Reward");

module.exports = function (deployer) {
  deployer.deploy(TheCollector, Reward.address);
};