// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract HackathonToken is ERC20, Ownable {
    constructor() ERC20("Hackathon Prague", "PRAGUE") {}

    mapping(address => bool) public hasMinted;
    mapping(address => bool) public allowList;

    function mint() public {
        require(hasMinted[msg.sender] == false, "You already own a token");
        require(allowList[msg.sender] == true, "Not allowed to mint");
        _mint(msg.sender, 1);
        hasMinted[msg.sender] = true;
    }

    function addToAllowlist(address[] calldata _addresses) external onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            allowList[_addresses[i]] = true;
        }
    }

}
