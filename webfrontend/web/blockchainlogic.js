Moralis.initialize("aQEtmAWQSGD54I81qQDvv6IHgDsJkVLp5M6xUsKa")
Moralis.serverURL = "https://f3jseekuuf5j.moralis.io:2053/server";


async function init() {
    console.log("Hallo von init");
    window.web3 = await Moralis.Web3.enable();
    window.NFTAuctioncontractInstance = new web3.eth.Contract(marketplaceAbi, addresses["marketplace"]);
    window.NFTTokencontractInstance = new web3.eth.Contract(thecollectorAbi, addresses["thecollector"]);
}

init()

async function bidForNFT(_tokenId, _bid, _uid) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    try {
        const bid = await NFTAuctioncontractInstance.methods.bid(_tokenId, _bid).send({ from: userAddress });
        if(bid["status"] == true) {
            const query = new Moralis.Query("ItemsForAuction");
            query.equalTo("uid", _uid);
            const result = await query.find();
            const object = result[0];
            object.set("highestBidder", userAddress),
            object.set("highestBid", _bid),
            object.save();
        }     
        return bid["status"];
    } catch (error) { console.log(error); }
}

async function createNewNFT(_file, _name, _description) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    let file = [];
    for (var i = 0; i < _file.length; i++) {
        file.push(_file[i]);
    }
    const object = {
        "name": _name,
        "description": _description,
        "file": file
    }
    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };

    try {
        //Store on IPFS get Hash in return
        const file = new Moralis.File("upload.json", { base64: btoa(JSON.stringify(object)) });
        await file.saveIPFS();
        let hash = file.ipfs();

        //Mint NFT and store Hash on blockchain in NFTToken.sol Contract
        let mint = await NFTTokencontractInstance.methods.mintNewCollectorNFT(hash).send({ from: userAddress });
        let nftId = mint.events.Transfer.returnValues.tokenId;

        return mint["status"];
    } catch (error) { console.log(error); }
}

async function getAllActiveAuctions() {
    try {
        //returns list with Id's of all active auctions
        let allAuctions = await NFTAuctioncontractInstance.methods.getAllActiveAuctions().call();
        return allAuctions;
    } catch (error) { console.log(error); }
}

async function getUserItems() {
    try {
        let userItems = [];
        const ownedItems = await Moralis.Cloud.run("getUserItems");
        for (var i = 0; i < ownedItems.length; i++) {
            useritem = JSON.stringify(ownedItems[i]);
            userItems.push(useritem);
        }
        return userItems;
    } catch (error) { console.log(error); }
}

async function getItemsForSale() {
    try {
        user = await Moralis.User.current();
        let ItemsForSale = [];
        const forSaleItems = await Moralis.Cloud.run("getItemsForSale");
        for (var i = 0; i < forSaleItems.length; i++) {

            item = JSON.stringify(forSaleItems[i]);
            ItemsForSale.push(item);
        }
        return ItemsForSale;
    } catch (error) { console.log(error); }
}

async function getItemsForAuction() {
    try {
        user = await Moralis.User.current();
        let ItemsForAuction = [];
        const forAuctionItems = await Moralis.Cloud.run("getItemsForAuction");
        for (var i = 0; i < forAuctionItems.length; i++) {

            item = JSON.stringify(forAuctionItems[i]);
            ItemsForAuction.push(item);
        }
        return ItemsForAuction;
    } catch (error) { console.log(error); }
}

async function getAuctionItem(_tokenId) {
    try {
        const query = new Moralis.Query("ItemsForAuction");
        query.equalTo("tokenId", _tokenId);
        const result = await query.find();
        console.log("Hallo von Javascript");
        console.log(_tokenId);
        console.log(result[0].get("ending"));
        const object = result[0];
        item = JSON.stringify(object);

        return item;
    } catch (error) { console.log(error); }
}

async function getMyTokens() {
    try {
        var tokenIds = [];
        var tokenHashes = [];

        //get balance of loggedIn account
        let balanceOf = await NFTTokencontractInstance.methods.balanceOf(ethereum.selectedAddress).call();

        //get all tokenIds fpr loggedIn account
        for (var i = 0; i < balanceOf; i++) {
            let tokenId = await await NFTTokencontractInstance.methods.tokenOfOwnerByIndex(ethereum.selectedAddress, i).call();
            tokenIds.push(tokenId);
        }

        //get all hashes of owners token
        for (var i = 0; i < tokenIds.length; i++) {
            let tokenHash = await NFTTokencontractInstance.methods.getTokenhash(tokenIds[i]).call();
            tokenHashes.push(tokenHash);
        }
        const returnobject = {
            "tokenId": tokenIds,
            "tokenHash": tokenHashes
        }
        return JSON.stringify(returnobject);
    } catch (error) { console.log(error); }
}

async function getAuctionData(_tokenId) {
    try {
        let data = await NFTAuctioncontractInstance.methods.getAuctionData(_tokenId).call();
        return [data[0], data[1], data[2], data[3]];
    } catch (error) { console.log(error); }
}


async function getTokenHash(_tokenId) {
    try {
        let tokenHash = await NFTTokencontractInstance.methods.getTokenhash(_tokenId).call();
        return tokenHash;
    } catch (error) { console.log(error) }
}

async function loggedIn() {
    try {
        user = await Moralis.User.current();
        return user.id
    } catch (error) { console.log(error); }
}

async function login() {
    try {
        user = await Moralis.User.current();
        if (!user) {
            var user = await Moralis.Web3.authenticate();
        }
        return user.id
    } catch (error) { console.log(error); }
}

async function logout() {
    try {
        user = await Moralis.User.logOut();
        return (Moralis.User.current());
    } catch (error) { console.log(error); }
}

async function removeAuction(_tokenId) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };

    try {
        let remove = await NFTAuctioncontractInstance.methods.deleteAuction(_tokenId).send({ from: userAddress });
        
        if(remove["status"] == true) {
            const query = new Moralis.Query("ItemsForAuction");
            query.equalTo("tokenId", _tokenId);
            const result = await query.find();
            const object = result[0];
            object.destroy();
        }       
        
        return remove["status"];
    } catch (error) { console.log(error); }
}

async function sellNFT(_tokenId, _price) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
        value: _price
    };

    try {
        let sellNFT = await NFTAuctioncontractInstance.methods.sellItem(_tokenId).send({ from: userAddress });
        return sellNFT["status"];
    } catch (error) { console.log(error); }
}

async function startNewAuction(_tokenId, _duration) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    try {
        //Approve NFT Auction Contract to use my NFT
        let approve = await NFTTokencontractInstance.methods.setApprovalForAll(addresses["marketplace"], "true").send({ from: userAddress });
        //Start Auction
        let auction = await NFTAuctioncontractInstance.methods.startAuction(_tokenId, _duration).send({ from: userAddress });

        return auction["status"];
    } catch (error) { console.log(error); }
}

async function startNewOffer(_tokenId, _price) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };

    try {
        //Approve NFT Auction Contract to use my NFT
        let approve = await NFTTokencontractInstance.methods.setApprovalForAll(addresses["marketplace"], "true").send({ from: userAddress });
        //Start Offer
        let offer = await NFTAuctioncontractInstance.methods.setOffer(_tokenId, _price).send({ from: userAddress });
        return offer["status"];
    } catch (error) { console.log(error); }
}

async function removeOffer(_tokenId) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    try {
        let remove = await NFTAuctioncontractInstance.methods.removeOffer(_tokenId).send({ from: userAddress });
        
        if(remove["status"] == true) {
            const query = new Moralis.Query("ItemsForSale");
            query.equalTo("tokenId", _tokenId);
            const result = await query.find();
            const object = result[0];
            object.destroy();
        }
        
        return remove["status"];
    } catch (error) { console.log(error); }
}

async function getMyBids() {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");
    let myBids = new Array();

    try {
            const query = new Moralis.Query("ItemsForAuction");
            query.equalTo("highestBidder", userAddress);
            const result = await query.find();

            for(var i = 0; i < result.length; i++){
                const object = {
                    "tokenId": result[i].get("tokenId"),
                    "highestBid": result[i].get("highestBid"),
                    "tokenuri": result[i].get("token").get("token_uri")
                }
                myBids.push(object);
            }
            console.log(myBids);
        
        //return object;
    } catch (error) { console.log(error); }
}

async function buy(_tokenId, _price) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    console.log(_price);
    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
        value: _price,
    };

    try {
        let buy = await NFTAuctioncontractInstance.methods.buyNFT(_tokenId).send({ from: userAddress, value: _price, });    
        
        if(buy["status"] == true) {
            const query = new Moralis.Query("ItemsForSale");
            query.equalTo("tokenId", _tokenId);
            const result = await query.find();
            const object = result[0];
            object.destroy();
        }       
        
        return buy["status"];
    } catch (error) { console.log(error); }
}

async function getAllActiveOffers() {
    try {
        let offers = await NFTAuctioncontractInstance.methods.getAllActiveOffers().call();
        return offers;
    } catch (error) { console.log(error); }
}

async function getOfferData(_tokenId) {
    try {
         let data = await NFTAuctioncontractInstance.methods.getOfferData(_tokenId).call();
        return [data[0], data[1]];
    } catch (error) { console.log(error); }
}