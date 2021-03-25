var NFTToken = artifacts.require("./NFTToken.sol");

module.exports =  async function(deployer) {
  await deployer.deploy(NFTToken);
};
