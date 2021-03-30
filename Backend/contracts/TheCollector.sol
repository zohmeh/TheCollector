pragma solidity 0.6.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract TheCollector is ERC721 {
    constructor() ERC721("TheCollcetorToken", "TCT") public {}

    event NewCollectorToken(string message, uint256 tokenId, string tokenHash);
    
    struct CollectorToken {
        string tokenHash;
    }

    CollectorToken[] collectorTokens;   
    
    //tokenId => hash
    mapping(uint256 => CollectorToken) tokenMap;

    function mintNewCollectorNFT(string memory _hash) public {
        CollectorToken memory _newToken;
        _newToken.tokenHash = _hash;
        
        collectorTokens.push(_newToken);
        uint256 _tokenId = collectorTokens.length;

        tokenMap[_tokenId].tokenHash = _hash;

        _mint(msg.sender, _tokenId);

        emit NewCollectorToken("New CollectorToken created", _tokenId, _hash);
    }


//---------Some Getterfunctions----------

    function getTokenhash(uint256 _tokenId) public view returns(string memory) {
        return tokenMap[_tokenId].tokenHash;
    }
}