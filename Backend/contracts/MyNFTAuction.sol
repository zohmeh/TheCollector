pragma solidity 0.6.2;

//import "../erc-1155/contracts/IERC1155.sol";
import "./INFTToken.sol";


contract MyNFTAuction {

    struct Auction {
        bool hasStarted;
        uint256 ending;
        uint256 highestBid;
        address highestBidder;
        address payable creator;
    }
    
    mapping(uint256 => Auction) auctionList;
    mapping(uint256 => uint256) tokenAmountTracking;
    uint256[] tokenList;
    //IERC1155 private token;
    INFTToken private nft;
    address public owner;
    
    constructor(address _token) public {
        require(address(this) != address(0));
        //token = IERC1155(_token);
        nft = INFTToken(_token);
        owner = msg.sender;
    }

    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4) {
        tokenList.push(_id);
        tokenAmountTracking[_id] = _value;
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4) {
        return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"));
    }

    function startAuction(uint256 _tokenId, uint256 _duration) public {
        require(msg.sender == nft.getCreator(_tokenId), "Only creator can start the Auction");
        require(auctionList[_tokenId].hasStarted == false, "Auction already started");
        
        auctionList[_tokenId].hasStarted = true;
        auctionList[_tokenId].ending = now + _duration * 1 seconds;
        auctionList[_tokenId].creator = msg.sender;
    }
    
    function bid(uint256 _tokenId, uint256 _bid) public {
        require(auctionList[_tokenId].hasStarted == true, "Auction has not started yet");
        require(_bid >= auctionList[_tokenId].highestBid, "You need to make an higher offer");
        require(now < auctionList[_tokenId].ending, "Auction already finished");
     
        auctionList[_tokenId].highestBid = _bid;
        auctionList[_tokenId].highestBidder = msg.sender;
    }
    
    function sellItem(uint256 _tokenId) public payable {
        require(msg.sender == auctionList[_tokenId].highestBidder, "You did not won the auction");
        require(msg.value == auctionList[_tokenId].highestBid, "Please send the correct bidding amount");
        require(now > auctionList[_tokenId].ending, "Auction not finished yet");
        
        uint256 tokenSendingAmount = tokenAmountTracking[_tokenId]; 
        tokenAmountTracking[_tokenId] -= 1;
        //token.safeTransferFrom(address(this), msg.sender, _tokenId, tokenSendingAmount, "");
        auctionList[_tokenId].creator.transfer(msg.value);
    }
    
    function withdraw() public {
        require(msg.sender == owner, "Only the contract owner can withdraw");
        
        msg.sender.transfer(address(this).balance);
    }

    //function() external payable {
    //    msg.sender.transfer(msg.value);
    //}

//--------------------Some Getter Functions----------------------------------------------------------------

    function getTokenList() public returns(uint256[] memory) {
        return tokenList;
    }

    function getTokenAmount(uint256 _tokenId) public returns(uint256) {
        return tokenAmountTracking[_tokenId];
    }

    function getCreator(uint256 _tokenId) public returns(address) {
        return nft.getCreator(_tokenId);
    }
}