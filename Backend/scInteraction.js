//Contract ABIs
const nftAuctionABI = require("./build/contracts/Marketplace.json");
const collectorABI = require("./build/contracts/TheCollector.json");
const collectorERC20ABI = require("./build/contracts/CollectorToken.json");
const rewardABI = require("./build/contracts/Reward.json");
const address = require("../addresses.json");
//const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require('web3');

// Connecting to the Ethereum Blockchain 
const web3 = new Web3("HTTP://127.0.0.1:7545");
//const web3 = new Web3(new HDWalletProvider("0x1eb8c810ad16b73f69b0bd9a169f938d4c3f88d039d3b1ad3d8c0ebe5245be57", "https://kovan.infura.io/v3/134eb24f9b9d410baa2acac76d2a7be3"));

// Connecting to SmartContract
const nftMarketplaceContract = new web3.eth.Contract(nftAuctionABI.abi, address.marketplace);
const collectorContract = new web3.eth.Contract(collectorABI.abi, address.thecollector);
const collectorERC20Contract = new web3.eth.Contract(collectorERC20ABI.abi, address.collectorERC20);
const rewardContract = new web3.eth.Contract(rewardABI.abi, address.reward);

module.exports = {
    approveERC20: async function (sendSettings, _address, _amount) {
        try {
            const approve = await collectorERC20Contract.methods.approve(_address, _amount).send(sendSettings);
            return approve;
        } catch (error) { console.log(error); }
    },

    balance: async function (_address) {
        try {
            const balance = await collectorERC20Contract.methods.balanceOf(_address).call();
            return balance;
        } catch (error) { console.log(error); }
    },

    allowanceERC20: async function (_owner, _spender) {
        try {
            const allowance = await collectorERC20Contract.methods.allowance(_owner, _spender).call();
            return allowance;
        } catch (error) { console.log(error); }
    },

    reward: async function (sendSettings, _recipient, _amount) {
        try {
            const pay = await rewardContract.methods.payReward(_recipient, _amount).send(sendSettings);
            return pay;
        } catch (error) { console.log(error); }
    },

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

    startNewOffer: async function(_tokenId, _price, sendSettings) {
        try {
            const offer = await nftMarketplaceContract.methods.setOffer(_tokenId, web3.utils.toWei(_price, "ether")).send(sendSettings);
            return offer;
        } catch (error) { console.log(error); }
    },

    removeOffer: async function(_tokenId, sendSettings) {
        try {
            const remove = await nftMarketplaceContract.methods.removeOffer(_tokenId).send(sendSettings);
            return remove;
        } catch (error) { console.log(error); }
    },

    buyNFT: async function(_tokenId, sendSettings) {
        try {
            const buy = await nftMarketplaceContract.methods.buyNFT(_tokenId).send(sendSettings);
            return buy;
        } catch (error) { console.log(error); }
    },

    bidForNFT: async function(_tokenId, _bid, sendSettings) {
        try {
            const bid = await nftMarketplaceContract.methods.bid(_tokenId, _bid).send(sendSettings);
            return bid;
        } catch (error) { console.log(error); }
    },

    removeAuction: async function(_tokenId, sendSettings) {
        try {
            const remove = await nftMarketplaceContract.methods.deleteAuction(_tokenId).send(sendSettings);
            return remove;
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

    getAllActiveOffers: async function() {
        try {
            const offers = await nftMarketplaceContract.methods.getAllActiveOffers().call();
            return offers;
        } catch (error) { console.log(error); }
    },
    
    getOfferData: async function(_tokenId) {
        try {
            const offer = await nftMarketplaceContract.methods.getOfferData(_tokenId).call();
            return offer;
        } catch (error) { console.log(error); }
    },

}
