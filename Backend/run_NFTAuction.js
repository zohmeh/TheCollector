const address = require("../addresses.json");
const SCInteraction = require("./scInteraction.js");
const web3 = require('web3');

const bid = web3.utils.toWei('1', 'ether');
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

reward = {
    from: address.reward,
    gasLimit: 6721975,
    gasPrice: web3.utils.toWei('20000000000', 'wei'),
};


async function logBalances(_event)
{
    return new Promise(async (resolve, reject) => {
      //let auctionatorETHBalance = await SCInteraction.getEthBalance(address.account[0]);
      //let bidderETHBalance = await SCInteraction.getEthBalance(address.account[1]);
      //let myNFTAuctionEthBalance = await SCInteraction.getEthBalance(address.myNFTAuction);
      //let auctionatorNFTBalances = await SCInteraction.getTokenIdsforOwner(address.account[0]);
      //let auctionatorHashes = await SCInteraction.getMyHashes(address.account[0]);
      //let bidderNFTBalances = await SCInteraction.getTokenIdsforOwner(address.account[1]);
      //let bidderHashes = await SCInteraction.getMyHashes(address.account[0]);
      //let myNFTAuctionNFTBalances = await SCInteraction.getTokenIdsforOwner(address.marketplace);
      
      //console.log(_event);
      //console.log("Auctionator Eth Balance:", auctionatorETHBalance);
      //console.log("Bidder Eth Balance:", bidderETHBalance);
      //console.log("MyNFTAuction Eth Balance:", myNFTAuctionEthBalance);
      //console.log("Auctionator  NFT Balance:", auctionatorNFTBalances);
      //console.log("Auctionator  Hashes:", auctionatorHashes);
      //console.log("Bidder NFT Balance:", bidderNFTBalances);
      //console.log("Bidder  Hashes:", bidderHashes);
      //console.log("MyNFTAuction NFT Balance:", myNFTAuctionNFTBalances); 

      //resolve();
    });
  };

async function main() {

    //approve reward contract to spend tokens
    //send tokens to reward contract with metamask

    //let approve = await SCInteraction.approveERC20(auctionator, address.reward, "100000000000000000000000");
    //console.log(approve);
    //let approve1 = await SCInteraction.approveERC20(auctionator, address.thecollector, "100000000000000000000000");
    //console.log(approve1);
    //let approve2 = await SCInteraction.approveERC20(auctionator, address.marketplace, "100000000000000000000000");
    //console.log(approve2);
    //let approve3 = await SCInteraction.approveERC20(auctionator, address.account[0], "100000000000000000000000");
    //console.log(approve3);

    //let balance = await SCInteraction.balance(address.reward);
    //console.log(balance);

    //let allowance = await SCInteraction.allowanceERC20(address.account[0], address.reward);
    //console.log(allowance);

    //let pay = await SCInteraction.reward(bidder, address.account[1], "1");
    //console.log(pay);

    //let create = await SCInteraction.createNewNFT(auctionator);
    //let id = create.events.NewCollectorToken.returnValues.tokenId;
    //console.log("Token Id: " , id);
    //logBalances("After Token Creating");

    //let approve = await SCInteraction.setApproval(address.marketplace, "1", auctionator);
    //let auction = await SCInteraction.startNewAuction("1", "1", auctionator);

    //let offer = await SCInteraction.startNewOffer("1", "1", auctionator);
    //let remove = await SCInteraction.removeOffer("1", auctionator);

    //let remove = await SCInteraction.removeAuction("1", auctionator);

    //let bidding = await SCInteraction.bidForNFT("1", bid, bidder);

    //let buy = await SCInteraction.buyNFT("1", bidderPay)

    //let sell = await SCInteraction.sellNFT("1", bidderPay);
    //logBalances("After Selling Token");

    //let creator = await SCInteraction.getOwnerAddress("1");
    //console.log(creator);

    //let auctionList = await SCInteraction.getAllActiveAuctions();
    //console.log(auctionList); 
    
    //let offerList = await SCInteraction.getAllActiveOffers();
    //console.log(offerList); 
    
    //let auction = await SCInteraction.getAuctionData("1");
    //console.log(auction); 

    //let offerData = await SCInteraction.getOfferData("1");
    //console.log(offerData); 

}

main();