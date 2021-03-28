pragma solidity 0.6.2;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./INFTToken.sol";


contract MyNFTAuction {

    struct Auction {
        bool hasStarted;
        uint256 ending;
        uint256 highestBid;
        address highestBidder;
    }
    
    mapping(uint256 => Auction) auctionList;
    uint256[] tokenList;
    INFTToken private collectorToken;
    IERC721 private nft;
    address public owner;
    
    constructor(address _token) public {
        require(address(this) != address(0));
        collectorToken = INFTToken(_token);
        nft = IERC721(_token);
        owner = msg.sender;
    }

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
    _operator;
    _from;
    _tokenId;
    _data;
    return 0x150b7a02;
  }

    function startAuction(uint256 _tokenId, uint256 _duration) public {
        require(collectorToken.getTokenCreator(_tokenId) == msg.sender, "Only owner of NFT can start Auction");
        require(auctionList[_tokenId].hasStarted == false, "Auction already started");
        
        auctionList[_tokenId].hasStarted = true;
        auctionList[_tokenId].ending = now + _duration * 1 minutes; 
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
        
        nft.approve(msg.sender, _tokenId);
        nft.safeTransferFrom(address(this), msg.sender, _tokenId); 
        address payable creator = collectorToken.getTokenCreator(_tokenId);
        creator.transfer(msg.value);
    }

    function getBackNFT(uint256 _tokenId) public {
        require(now > auctionList[_tokenId].ending, "Auction not finished yet");
        require(auctionList[_tokenId].highestBid == 0, "There was a bid for your token");
        require(msg.sender == collectorToken.getTokenCreator(_tokenId), "You are not the creator of this token");

        auctionList[_tokenId].hasStarted = false;
        nft.approve(msg.sender, _tokenId);
        nft.safeTransferFrom(address(this), msg.sender, _tokenId);
    }

//--------------------Some Getter Functions----------------------------------------------------------------

    function getHighestBidder(uint256 _tokenId) public returns(address) {
        return auctionList[_tokenId].highestBidder;
    }

    function getHighestBid(uint256 _tokenId) public returns(uint256) {
        return auctionList[_tokenId].highestBid;
    }
}