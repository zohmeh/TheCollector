Moralis.initialize("GTdkvs8iE0T2SPLZt55dXDl4DTYu5LaNzIC9IK23")
Moralis.serverURL = "https://geuznmdttxzt.moralis.io:2053/server";

async function bidForNFT(_tokenId, _bid) {
    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    }

    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["marketplace"]);
        const bid = await NFTAuctioncontractInstance.methods.bid(_tokenId, _bid).send(sendsettings);
        return bid;
    } catch (error) { console.log(error); }
}

async function createNewNFT(_file, _name, _description) {
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
        console.log(hash);
        //Mint NFT and store Hash on blockchain in NFTToken.sol Contract
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["thecollector"]);
        let mint = await NFTTokencontractInstance.methods.mintNewCollectorNFT(hash).send(sendsettings);
        return mint;
    } catch (error) { console.log(error); }
}

async function getAllActiveAuctions() {
    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };
    
    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["marketplace"]);

        //returns list with Id's of all active auctions
        let allAuctions = await NFTAuctioncontractInstance.methods.getAllActiveAuctions().call();
        return allAuctions;
    } catch (error) { console.log(error); }
}

async function getMyTokens() {
    try {
        var tokenIds = [];
        var tokenHashes = [];

        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["thecollector"]);

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
        window.web3 = await Moralis.Web3.enable();
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["marketplace"]);

        let data = await NFTAuctioncontractInstance.methods.getAuctionData(_tokenId).call();
        return [data[0], data[1], data[2], data[3]];
    } catch (error) { console.log(error); }
}


async function getTokenHash(_tokenId) {
    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["thecollector"]);

        let tokenHash = await NFTTokencontractInstance.methods.getTokenhash(_tokenId).call();
        return tokenHash;
    } catch (error) { console.log(error) }
}

async function loggedIn() {
    try {
        user = await Moralis.User.current();
    } catch (error) { console.log(error); }
    return ethereum.selectedAddress
}

async function login() {
    try {
        user = await Moralis.User.current();
        if (!user) {
            var user = await Moralis.Web3.authenticate();
        }
    } catch (error) { console.log(error); }
    return ethereum.selectedAddress
}

async function logout() {
    try {
        user = await Moralis.User.logOut();
    } catch (error) { console.log(error); }
}

async function removeAuction(_tokenId) {
    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };

    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["marketplace"]);

        let remove = await NFTAuctioncontractInstance.methods.deleteAuction(_tokenId).send(sendsettings);
        return remove;
    } catch (error) { console.log(error); }
}

async function sellNFT(_tokenId, _price) {
    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
        value: _price
    };

    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["marketplace"]);

        let sellNFT = await NFTAuctioncontractInstance.methods.sellItem(_tokenId).send(sendsettings);
        return sellNFT;
    } catch (error) { console.log(error); }
}

async function startNewAuction(_tokenId, _duration) {
    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };

    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["thecollector"]);
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["marketplace"]);

        //Approve NFT Auction Contract to use my NFT
        let approve = await NFTTokencontractInstance.methods.setApprovalForAll(addresses["marketplace"], "true").send(sendsettings);
        //Start Auction
        let auction = await NFTAuctioncontractInstance.methods.startAuction(_tokenId, _duration).send(sendsettings);
        return auction;
    } catch (error) { console.log(error); }
}