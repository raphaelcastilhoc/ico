//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleTransfer is ERC20 {
    address public treasury;
    address public owner;

    constructor(address _treasury, address _owner) ERC20("SimpleTransfer", "SPC") {
        owner = _owner;
        treasury = _treasury;
        _mint(_msgSender(), 150000);
        _mint(treasury, 350000);
    }

    function simpleTransfer(address recipient, uint256 amount) public returns (bool) {
        if(amount > 1000) {
            revert("Amount is too high");
        }

        if (amount > 100) {
            uint256 tax = 2;
            uint256 amountAfterTax = amount - tax;
            _transfer(_msgSender(), treasury, tax);
            _transfer(_msgSender(), recipient, amountAfterTax);
        } else {
            _transfer(_msgSender(), recipient, amount);
        }
    }
}
