//Contract ABIs
const nftAuctionABI = require("./build/contracts/Marketplace.json");
const collectorABI = require("./build/contracts/TheCollector.json");
const address = require("../addresses.json");
//const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require('web3');

// Connecting to the Ethereum Blockchain 
const web3 = new Web3("HTTP://127.0.0.1:7545");
//const web3 = new Web3(new HDWalletProvider("0x1eb8c810ad16b73f69b0bd9a169f938d4c3f88d039d3b1ad3d8c0ebe5245be57", "https://kovan.infura.io/v3/134eb24f9b9d410baa2acac76d2a7be3"));

// Connecting to SmartContract
const nftMarketplaceContract = new web3.eth.Contract(nftAuctionABI.abi, address.marketplace);
const collectorContract = new web3.eth.Contract(collectorABI.abi, address.thecollector);

module.exports = {
    createNewNFT: async function (sendSettings) {
        try {
            const nftID = await collectorContract.methods.mintNewCollectorNFT("Hallo erster Hash").send(sendSettings);
            return nftID;
        } catch (error) { console.log(error); }
    },

    setApproval: async function (_operator, _tokenId, _sendSettings) {
        try {
            const approve = await collectorContract.methods.setApprovalForAll(_operator, "true").send(_sendSettings);
            return approve;
        } catch (error) { console.log(error); }
    },

    getApproval: async function (_owner, _operator) {
        try {
            const isApproved = await collectorContract.methods.isApprovedForAll(_owner, _operator).call();
            return isApproved;
        } catch (error) { console.log(error); }
    },

    getNFTBalance: async function (_owner) {
        try {
            const balance = await collectorContract.methods.balanceOf(_owner).call();
            return balance;
        } catch (error) { console.log(error); }
    },

    getTokenIdsforOwner: async function (_owner) {
        var tokens = [];
        try {
            const balanceOf = await collectorContract.methods.balanceOf(_owner).call();
            for(var i = 0; i < balanceOf ; i++) {
                const ownerTokensId = await collectorContract.methods.tokenOfOwnerByIndex(_owner, i).call();
                tokens.push(ownerTokensId);
            }
            return tokens;
        } catch (error) { console.log(error); }
    },

    getMyHashes: async function (_owner) {
        var hashes = [];
        try {
            const tokenIds = await this.getTokenIdsforOwner(_owner);
            for(var i = 0; i < tokenIds.length; i++) {
                const hash = await collectorContract.methods.getTokenhash(tokenIds[i]).call();
                hashes.push(hash);
            }
            return hashes;
        } catch (error) { console.log(error); }
    },

    transferNFT: async function(_from, _to, _tokenId, _sendSettings) {
        try {
            const transfer = await collectorContract.methods.safeTransferFrom(_from, _to, _tokenId).send(_sendSettings);
            return transfer;
        } catch (error) { console.log(error); }
    },

    getEthBalance: async function(_accountAddress) {
        
        try{
            const balance = await web3.eth.getBalance(_accountAddress);         
            return balance / 1000000000000000000;
        } catch(error) {console.log(error);}
    },

    startNewAuction: async function(_tokenId, _duration, sendSettings) {
        try {
            const auction = await nftMarketplaceContract.methods.startAuction(_tokenId, _duration).send(sendSettings);
            return auction;
        } catch (error) { console.log(error); }
    },

    bidForNFT: async function(_tokenId, _bid, sendSettings) {
        try {
            const bid = await nftMarketplaceContract.methods.bid(_tokenId, _bid).send(sendSettings);
            return bid;
        } catch (error) { console.log(error); }
    },

    sellNFT: async function(_tokenId, sendSettings) {
        try {
            const sell = await nftMarketplaceContract.methods.sellItem(_tokenId).send(sendSettings);
            return sell;
        } catch (error) { console.log(error); }
    },

    getBackNFT: async function(_tokenId, sendSettings) {
        try {
            const getback = await nftMarketplaceContract.methods.getBackNFT(_tokenId).send(sendSettings);
            return getback;
        } catch (error) { console.log(error); }
    },

    withdraw: async function(sendSettings) {
        try {
            const withdraw = await nftMarketplaceContract.methods.withdraw().send(sendSettings);
            return withdraw;
        } catch (error) { console.log(error); }
    },

    getOwnerAddress: async function(_tokenId) {
        try {
            const creator = await collectorContract.methods.ownerOf(_tokenId).call();
            return creator;
        } catch (error) { console.log(error); }
    },

    getAllActiveAuctions: async function() {
        try {
            const auctions = await nftMarketplaceContract.methods.getAllActiveAuctions().call();
            return auctions;
        } catch (error) { console.log(error); }
    },

    getAuctionData: async function(_tokenId) {
        try {
            const auction = await nftMarketplaceContract.methods.getAuctionData(_tokenId).call();
            return auction;
        } catch (error) { console.log(error); }
    },

}
