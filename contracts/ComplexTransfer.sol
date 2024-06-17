//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ComplexTransfer is ERC20 {
    address public treasury;
    address public owner;

    constructor(address _treasury, address _owner) ERC20("ComplexTransfer", "SPC") {
        owner = _owner;
        treasury = _treasury;
        _mint(_msgSender(), 150000);
        _mint(treasury, 350000);
    }

    function complexTransfer(address recipient, uint256 amount) public returns (bool) {
        uint256 tax;
        if (amount > 100) {
            tax = 6;
        } else if(amount > 80) {
            tax = 5;
        } else if(amount > 60) {
            tax = 4;
        } else if(amount > 40) {
            tax = 3;
        } else if(amount > 20) {
            tax = 2;
        } else if(amount > 10) {
            tax = 1;
        } else {
            _transfer(_msgSender(), recipient, amount);
            return true;
        }

        uint256 amountAfterTax = amount - tax;
        _transfer(_msgSender(), treasury, tax);
        _transfer(_msgSender(), recipient, amountAfterTax);

        return true;
    }
}
