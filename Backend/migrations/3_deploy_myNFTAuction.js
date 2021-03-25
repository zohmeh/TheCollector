var NFTToken = artifacts.require("./NFTToken.sol");
const MyNFTAuction = artifacts.require("MyNFTAuction");

module.exports = function (deployer) {
  deployer.deploy(MyNFTAuction, NFTToken.address);
};