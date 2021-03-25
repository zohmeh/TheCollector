Moralis.initialize("0zWFBUq1GpyS9LSHZhWaxw4g6kAoMqkhrdgo1r2n")
Moralis.serverURL = "https://d4xipmsrvcb7.moralis.io:2053/server";

async function addToIPFS(_file, _name, _description) {
    const object = {
        "name" : _name,
        "description": _description,
        "file": _file
      }
    
    try {
        const file = new Moralis.File("file.json", {base64 : btoa(JSON.stringify(object))});
        await file.saveIPFS();
        console.log(file.ipfs());
        return file.ipfs();
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

async function setMeme(_memeHash) {

    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };
    try {
        window.web3 = await Moralis.Web3.enable();
        let contractInstance = new web3.eth.Contract(window.abi, "0xE7E7d0A2133E6980c8D7504A1Cd54B188032Ef1e");
        let receipt = await contractInstance.methods.set(_memeHash).send(sendsettings);
    } catch (error) { console.log(error); }
}

async function getMeme() {

    sendsettings = {
        from: ethereum.selectedAddress,
        gasLimit: 6721975,
        gasPrice: '20000000000',
    };
    try {
        window.web3 = await Moralis.Web3.enable();
        let contractInstance = new web3.eth.Contract(window.abi, "0xE7E7d0A2133E6980c8D7504A1Cd54B188032Ef1e");
        let receipt = await contractInstance.methods.get().call();
        return receipt;
    } catch (error) { console.log(error); }
}