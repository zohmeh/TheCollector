pragma solidity 0.6.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Reward {

    IERC20 erc20;

    constructor(address _erc20) public {
        erc20 = IERC20(_erc20);
    }

    function payReward(address _recipient, uint256 _amount) public {
        erc20.approve(msg.sender, _amount);
        erc20.approve(_recipient, _amount);
        erc20.transfer(_recipient, _amount);
    }
}