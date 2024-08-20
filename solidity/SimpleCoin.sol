//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SimpleCoin is ERC20, ReentrancyGuard {
    address public owner;

    constructor(address _owner) ERC20("SimpleCoin", "SPC") {
        owner = _owner;
        _mint(_msgSender(), 150000);
    }

    modifier onlyValidParameters(uint256 amountToTransfer, uint maxtax) {
        require(amountToTransfer > 0, "Amount must be greater than 0");
        require(maxtax > 0, "Max tax must be greater than 0");
        _;
    }

    modifier onlyValidRecipient(address recipient) {
        require(recipient != owner, "Recipient must be different from owner");
        _;
    }

    modifier onlyValidSender() {
        require(msg.sender != owner, "Sender must be different from owner");
        _;
    }

    function transfer(address recipient, uint256 amount, uint maxTax) public 
    onlyValidParameters(amount, maxTax) nonReentrant onlyValidRecipient(recipient) onlyValidSender {
        uint256 amountAfterTax = amount - maxTax;
        _transfer(_msgSender(), recipient, amountAfterTax);
    }
}
