const Reward = artifacts.require("Reward");
const CollectorToken = artifacts.require("CollectorToken")

module.exports =  function (deployer) {
  deployer.deploy(Reward, CollectorToken.address);
};