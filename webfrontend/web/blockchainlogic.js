Moralis.initialize("0zWFBUq1GpyS9LSHZhWaxw4g6kAoMqkhrdgo1r2n")
Moralis.serverURL = "https://d4xipmsrvcb7.moralis.io:2053/server";

async function createNewNFT(_file, _name, _description) {
    let file = [];
    for(var i=0; i<_file.length;i++){
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
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["nftToken"]);
        let mint = await NFTTokencontractInstance.methods.mintNewCollectorNFT(hash).send(sendsettings);
        return mint;
    } catch (error) { console.log(error); }
}

async function getMyTokens() {
    try{
        var tokenIds = [];
        var tokenHashes = [];
        
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["nftToken"]);
        
        //get balance of loggedIn account
        let balanceOf =  await NFTTokencontractInstance.methods.balanceOf(ethereum.selectedAddress).call();
        
        //get all tokenIds fpr loggedIn account
        for(var i = 0; i < balanceOf; i++) {
            let tokenId = await await NFTTokencontractInstance.methods.tokenOfOwnerByIndex(ethereum.selectedAddress, i).call();
            tokenIds.push(tokenId);    
        }

        //get all hashes of owners token
        for(var i = 0; i < tokenIds.length; i++){
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

async function getAuctionTokens() {
    try{
        var tokenIds = [];
        var tokenHashes = [];
        
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["nftToken"]);
        
        //get balance of loggedIn account
        let balanceOf =  await NFTTokencontractInstance.methods.balanceOf(addresses["myNFTAuction"]).call();
        
        //get all tokenIds fpr loggedIn account
        for(var i = 0; i < balanceOf; i++) {
            let tokenId = await NFTTokencontractInstance.methods.tokenOfOwnerByIndex(addresses["myNFTAuction"], i).call();
            tokenIds.push(tokenId);    
        }

        //get all hashes of owners token
        for(var i = 0; i < tokenIds.length; i++){
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

async function getTokenHash(_tokenId) {
    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["nftToken"]);

        let tokenHash = await NFTTokencontractInstance.methods.getTokenhash(_tokenId).call();
        return tokenHash;
    } catch (error) { console.log(error) }
}

async function startNewAuction(_tokenId, _duration) {
    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };

    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, addresses["nftToken"]);
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["myNFTAuction"]);

        //Approve NFT Auction Contract to use my NFT
        let approve = await NFTTokencontractInstance.methods.approve(addresses["myNFTAuction"], _tokenId).send(sendsettings);
        //Send my NFT to Auction Contract
        let send = await NFTTokencontractInstance.methods.safeTransferFrom(ethereum.selectedAddress, addresses["myNFTAuction"], _tokenId).send(sendsettings);
        //Start Auction
        let auction = await NFTAuctioncontractInstance.methods.startAuction(_tokenId, _duration).send(sendsettings);
        return auction;
    } catch (error) { console.log(error); }
}

async function gettingHighestBid(_tokenId) {
    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["myNFTAuction"]);

        let highestBid = await NFTAuctioncontractInstance.methods.getHighestBid(_tokenId).call();
        return highestBid;
    } catch (error) { console.log(error); }
}

async function getHighestBidder(_tokenId) {
    try {
        window.web3 = await Moralis.Web3.enable();
        let NFTAuctioncontractInstance = new web3.eth.Contract(window.abi, addresses["myNFTAuction"]);

        let highestBid = await NFTAuctioncontractInstance.methods.getHighestBidder(_tokenId).call();
        return highestBid;
    } catch (error) { console.log(error); }
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

async function loggedIn() {
    try {
        user = await Moralis.User.current();
    } catch (error) { console.log(error); }
    return ethereum.selectedAddress
}

async function logout() {
    try {
        user = await Moralis.User.logOut();
    } catch (error) { console.log(error); }
}