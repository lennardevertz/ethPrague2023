// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HackathonToken is ERC20 {
    constructor() ERC20("Hackathon Token", "HACK") {}

    mapping(address => uint256) public hasMinted;

    function mint() public {
        require(hasMinted[msg.sender] == 0, "You already own a token");
        _mint(msg.sender, 1);
        hasMinted[msg.sender] = 1;
    }

    // Additional functionality for future integration with attendance NFTs can be added here
}
