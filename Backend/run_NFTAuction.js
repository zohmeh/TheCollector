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

async function logBalances(_event, _tokenId)
{
    return new Promise(async (resolve, reject) => {
      let auctionatorETHBalance = await SCInteraction.getEthBalance(address.account[0]);
      let bidderETHBalance = await SCInteraction.getEthBalance(address.account[1]);
      let myNFTAuctionEthBalance = await SCInteraction.getEthBalance(address.myNFTAuction);
      let auctionatorNFTBalances = await SCInteraction.getNFTBalance([_tokenId], [address.account[0]]);
      let bidderNFTBalances = await SCInteraction.getNFTBalance([_tokenId], [address.account[1]]);
      let myNFTAuctionNFTBalances = await SCInteraction.getNFTBalance([_tokenId], [address.myNFTAuction]);
      
      console.log(_event);
      console.log("Auctionator Eth Balance:", auctionatorETHBalance);
      console.log("Bidder Eth Balance:", bidderETHBalance);
      console.log("MyNFTAuction Eth Balance:", myNFTAuctionEthBalance);
      console.log("Auctionator  NFT Balance:", auctionatorNFTBalances);
      console.log("Bidder NFT Balance:", bidderNFTBalances);
      console.log("MyNFTAuction NFT Balance:", myNFTAuctionNFTBalances); 

      resolve();
    });
  };

async function main() {

    let create = await SCInteraction.createNewNFT(auctionator);
    let id = create.events.TransferSingle.returnValues._id;
    console.log("Token Id: " , id);
    logBalances("After Token Creating", id);
/*        
    let mint = await SCInteraction.mintNewNFT(id, [address.myNFTAuction], ["1"], auctionator);
    
    let tokenList = await SCInteraction.getTokenList.call();
    console.log(tokenList);
    
    let creator = await SCInteraction.getCreatorAddress(id);
    console.log("Token Creator: " , creator);

    logBalances("After Token Minting", id);

    let auction = await SCInteraction.startNewAuction(id, "10", auctionator);

    let bidding = await SCInteraction.bidForNFT(id, bid, bidder);

    //let isApproved = await SCInteraction.getApproval(address.account[0], address.myNFTAuction);
    //console.log(isApproved);

    //let aprroval = await SCInteraction.setApproval(address.myNFTAuction, "true", auctionator);

    let tokenIdList = await SCInteraction.getTokenList.call();
    console.log(tokenIdList);
    logBalances("Before Sending", tokenIdList[0]);

    let sell = await SCInteraction.sellNFT(tokenIdList[0], bidderPay);

    logBalances("After Sending", tokenIdList[0]);
*/
}

main();