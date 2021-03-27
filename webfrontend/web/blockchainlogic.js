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
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, "0xE34aD9dFf19AA45f143A41CD21298f55F89db610");
        let mint = await NFTTokencontractInstance.methods.mintNewCollectorNFT(hash).send(sendsettings);
        return mint;
    } catch (error) { console.log(error); }
}

async function getMyTokens() {
    try{
        var tokenIds = [];
        var tokenHashes = [];
        
        window.web3 = await Moralis.Web3.enable();
        let NFTTokencontractInstance = new web3.eth.Contract(window.abi, "0xE34aD9dFf19AA45f143A41CD21298f55F89db610");
        
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
        return tokenHashes;
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