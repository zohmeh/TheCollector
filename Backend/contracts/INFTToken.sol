pragma solidity 0.6.2;

/**
    Note: The ERC-165 identifier for this interface is 0x4e2312e0.
*/
interface INFTToken {
    function getTokenCreator(uint256 _tokenId) external returns(address payable);
}
