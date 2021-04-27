Moralis.initialize("NxlkAbcOLT1iC0fHcjPogrKjqMuiO1NmtutpVdl8")
Moralis.serverURL = "https://k1wcf9mxn8od.moralis.io:2053/server";


async function init() {
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
        if (bid["status"] == true) {
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

    try {
        //Store on IPFS get Hash in return
        const file = new Moralis.File("upload.json", { base64: btoa(JSON.stringify(object)) });
        await file.saveIPFS();
        let hash = file.ipfs();

        //Mint NFT and store Hash on blockchain in NFTToken.sol Contract
        let mint = await NFTTokencontractInstance.methods.mintNewCollectorNFT(hash).send({ from: userAddress });
        let nftId = mint.events.Transfer.returnValues.tokenId;

        if (mint["status"] == true) {
            const Item = Moralis.Object.extend("Item");
            const item = new Item();

            item.set("creator", user);
            item.set("tokenId", nftId);

            item.save()
        }

        return mint["status"];
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
        const object = result[0];
        item = JSON.stringify(object);

        return item;
    } catch (error) { console.log(error); }
}

async function getOfferItem(_tokenId) {
    try {
        const query = new Moralis.Query("ItemsForSale");
        query.equalTo("tokenId", _tokenId);
        const result = await query.find();
        const object = result[0];
        item = JSON.stringify(object);

        return item;
    } catch (error) { console.log(error); }
}

async function loggedIn() {
    try {
        user = await Moralis.User.current();
        let name = user.get("username");
        let avatar = user.get("avatar");
        return [name, avatar];
    } catch (error) { console.log(error); }
}

async function login() {
    try {
        user = await Moralis.User.current();
        if (!user) {
            var user = await Moralis.Web3.authenticate();
        }
        let name = user.get("username");
        let avatar = user.get("avatar");
        return [name, avatar];
    } catch (error) { console.log(error); }
}

async function logout() {
    try {
        user = await Moralis.User.logOut();
        return (Moralis.User.current());
    } catch (error) { console.log(error); }
}

async function setUserData(_file, _username) {
    user = await Moralis.User.current();
    let file = [];
    for (var i = 0; i < _file.length; i++) {
        file.push(_file[i]);
    }
    try {
        if (user) {
            user.set("username", _username);
            user.set("avatar", file);
            return _username;
        }
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

        if (remove["status"] == true) {
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

    try {
        let sellNFT = await NFTAuctioncontractInstance.methods.sellItem(_tokenId).send({ from: userAddress, value: _price });

        if (sellNFT["status"] == true) {
            const query = new Moralis.Query("ItemsForAuction");
            query.equalTo("tokenId", _tokenId);
            const result = await query.find();
            const object = result[0];
            object.destroy();
        }

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

        if (remove["status"] == true) {
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

        for (var i = 0; i < result.length; i++) {
            const token = result[i].get("token");
            await token.fetch();
            const uri = token.get("token_uri");

            const object = {
                "tokenId": result[i].get("tokenId"),
                "highestBid": result[i].get("highestBid"),
                "ending": result[i].get("ending"),
                "tokenuri": uri,
            }
            myBids.push(JSON.stringify(object));
        }
        return myBids;
    } catch (error) { console.log(error); }
}

async function buy(_tokenId, _price) {
    user = await Moralis.User.current();
    const userAddress = user.get("ethAddress");

    try {
        let buy = await NFTAuctioncontractInstance.methods.buyNFT(_tokenId).send({ from: userAddress, value: _price, });

        if (buy["status"] == true) {
            const query = new Moralis.Query("ItemsForSale");
            query.equalTo("tokenId", _tokenId);
            const result = await query.find();
            const object = result[0];
            object.destroy();

            const queryItem = new Moralis.Query("Item");
            queryItem.equalTo("tokenId", _tokenId);
            const item = await queryItem.first();
            item.set("price", _price);
            item.save();
        }

        return buy["status"];
    } catch (error) { console.log(error); }
}