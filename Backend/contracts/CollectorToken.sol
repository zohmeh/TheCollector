pragma solidity 0.6.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CollectorToken is ERC20 {

    constructor() ERC20("CollectorToken", "CT") public {
    }

    function mintToken(address account, uint256 amount) public {
        _mint(account, amount);
    }
}