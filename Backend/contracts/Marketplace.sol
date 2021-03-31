pragma solidity 0.6.2;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./TheCollector.sol";

contract Marketplace {

    struct Auction {
        uint256 tokenId;
        bool hasStarted;
        uint256 ending;
        uint256 highestBid;
        address highestBidder;
    }
    
    //tokenId => Auctiondata
    mapping(uint256 => Auction) auctionMap;
    Auction[] auctionList;
    address public owner;
    TheCollector collector;

    constructor(address _collector) public {
        require(address(this) != address(0));
        owner = msg.sender;
        collector = TheCollector(_collector);
    }

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4) {
    _operator;
    _from;
    _tokenId;
    _data;
    return 0x150b7a02;
  }

    function startAuction(uint256 _tokenId, uint256 _duration) public {
        require(collector.ownerOf(_tokenId) == msg.sender, "Only owner of NFT can start Auction");
        require(auctionMap[_tokenId].hasStarted == false, "Auction already started");
        require(collector.isApprovedForAll(msg.sender, address(this)), "The Marketplace is not approved as operator for your token");

        Auction memory _auction = Auction({
            tokenId: _tokenId,
            hasStarted: true,
            ending: now + _duration * 1 minutes,
            highestBid: 0,
            highestBidder: address(0)
        });

        auctionList.push(_auction);
        auctionMap[_tokenId] = _auction;
 
    }
    
    function bid(uint256 _tokenId, uint256 _bid) public {
        require(auctionMap[_tokenId].hasStarted == true, "Auction has not started yet");
        require(_bid >= auctionMap[_tokenId].highestBid, "You need to make an higher offer");
        require(now < auctionMap[_tokenId].ending, "Auction already finished");
     
        auctionMap[_tokenId].highestBid = _bid;
        auctionMap[_tokenId].highestBidder = msg.sender;
    }
    
    function sellItem(uint256 _tokenId) public payable {
        require(msg.sender == auctionMap[_tokenId].highestBidder, "You did not won the auction");
        require(msg.value == auctionMap[_tokenId].highestBid, "Please send the correct bidding amount");
        require(now > auctionMap[_tokenId].ending, "Auction not finished yet");
        
        delete auctionMap[_tokenId];
        
        collector.approve(msg.sender, _tokenId);
        address payable originalOwner = payable(collector.ownerOf(_tokenId));
        collector.safeTransferFrom(originalOwner, msg.sender, _tokenId); 
        originalOwner.transfer(msg.value);
    }

//--------------------Some Getter Functions----------------------------------------------------------------

    function getAuctionData(uint256 _tokenId) public view returns(bool, uint256, uint256, address) {
        return (auctionMap[_tokenId].hasStarted, auctionMap[_tokenId].ending, auctionMap[_tokenId].highestBid, auctionMap[_tokenId].highestBidder);
    }

    function getAllActiveAuctions() public returns(uint256[] memory) {
        uint256[] memory _result = new uint256[](auctionList.length);
        uint256 _auctionId;
        for(_auctionId = 0; _auctionId < auctionList.length; _auctionId++)
        {
            if(auctionMap[auctionList[_auctionId].tokenId].hasStarted == true){
                _result[_auctionId] = auctionList[_auctionId].tokenId;
            }
        }
        return _result;
    }
}