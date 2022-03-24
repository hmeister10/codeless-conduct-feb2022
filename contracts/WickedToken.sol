// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WickedToken is ERC20 {
 
    constructor() ERC20("wickedToken", "WICKED") {}

    function mint(address to, uint256 amount) internal {
        _mint(to, amount);
    }
}
