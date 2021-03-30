const address = require("../addresses.json");
const SCInteraction = require("./scInteraction.js");
const web3 = require('web3');

const bid = web3.utils.toWei('10', 'ether');
// Sending Settings
auctionator = {
    from: address.account[0],
    gasLimit: 6721975,
    gasPrice: web3.utils.toWei('20000000000', 'wei'),
};

bidder = {
    from: address.account[1],
    gasLimit: 6721975,
    gasPrice: web3.utils.toWei('20000000000', 'wei'),
};

bidderPay = {
    from: address.account[1],
    gasLimit: 6721975,
    gasPrice: web3.utils.toWei('20000000000', 'wei'),
    value: bid
};

async function logBalances(_event)
{
    return new Promise(async (resolve, reject) => {
      //let auctionatorETHBalance = await SCInteraction.getEthBalance(address.account[0]);
      //let bidderETHBalance = await SCInteraction.getEthBalance(address.account[1]);
      //let myNFTAuctionEthBalance = await SCInteraction.getEthBalance(address.myNFTAuction);
      let auctionatorNFTBalances = await SCInteraction.getTokenIdsforOwner(address.account[0]);
      //let auctionatorHashes = await SCInteraction.getMyHashes(address.account[0]);
      let bidderNFTBalances = await SCInteraction.getTokenIdsforOwner(address.account[1]);
      //let bidderHashes = await SCInteraction.getMyHashes(address.account[0]);
      let myNFTAuctionNFTBalances = await SCInteraction.getTokenIdsforOwner(address.marketplace);
      
      console.log(_event);
      //console.log("Auctionator Eth Balance:", auctionatorETHBalance);
      //console.log("Bidder Eth Balance:", bidderETHBalance);
      //console.log("MyNFTAuction Eth Balance:", myNFTAuctionEthBalance);
      console.log("Auctionator  NFT Balance:", auctionatorNFTBalances);
      //console.log("Auctionator  Hashes:", auctionatorHashes);
      console.log("Bidder NFT Balance:", bidderNFTBalances);
      //console.log("Bidder  Hashes:", bidderHashes);
      console.log("MyNFTAuction NFT Balance:", myNFTAuctionNFTBalances); 

      resolve();
    });
  };

async function main() {
/*
    let create = await SCInteraction.createNewNFT(auctionator);
    let id = create.events.NewCollectorToken.returnValues.tokenId;
    console.log("Token Id: " , id);
    logBalances("After Token Creating");

    let approve = await SCInteraction.setApproval(address.marketplace, "1", auctionator);
    let auction = await SCInteraction.startNewAuction("1", "1", auctionator);

    let bidding = await SCInteraction.bidForNFT("1", bid, bidder);
*/
    let sell = await SCInteraction.sellNFT("1", bidderPay);
    logBalances("After Selling Token");

    //let creator = await SCInteraction.getOwnerAddress("1");
    //console.log(creator);
  
    //let highestBid = await SCInteraction.getHighestBid("1");
    //console.log(highestBid);

    

}

main();