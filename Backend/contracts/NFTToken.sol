pragma solidity 0.6.2;

//import "../erc-1155/contracts/IERC1155.sol";
//import "../erc-1155/contracts/ERC1155Mintable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTToken is ERC721 {//IERC1155, ERC1155Mintable {
    constructor() ERC721("TheCollcetorToken", "TCT") public {}

    event NewCollectorToken(string message, uint256 tokenId, string tokenHash);
    
    struct CollectorToken {
        string tokenHash;
    }

    CollectorToken[] collectorTokens;   
    
    //tokenId => hash
    mapping(uint256 => string) tokenHashMap;



    function mintNewCollectorNFT(string memory _hash) public {
        CollectorToken memory _newToken;
        _newToken.tokenHash = _hash;
        
        collectorTokens.push(_newToken);
        uint256 _tokenId = collectorTokens.length;

        tokenHashMap[_tokenId] = _hash;

        _mint(msg.sender, _tokenId);

        emit NewCollectorToken("New CollectorToken created", _tokenId, _hash);
    }


//---------Some Getterfunctions----------

    //function getCreator(uint256 _tokenId) public returns(address) {
    //    return creators[_tokenId];
    //}

    function getTokenhash(uint256 _tokenId) public view returns(string memory) {
        return tokenHashMap[_tokenId];
    }

}