pragma solidity ^0.5.0;

/**
    Note: The ERC-165 identifier for this interface is 0x4e2312e0.
*/
interface INFTToken {
    function getCreator(uint256 _tokenId) external returns(address);
}
