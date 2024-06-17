//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Ico.sol";

contract SpaceCoin is ERC20 {
    address public treasury;
    address public owner;
    bool public taxEnabled = true;
    Ico public ico;
    string public INVALID_AMOUNT_MESSAGE = "Amount is invalid";

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyICO() {
        require(msg.sender == address(ico), "Only ICO can call this function");
        _;
    }

    modifier onlyValidParameters(uint256 transferingAmount, address recipient) {
        require(transferingAmount > 0, "Amount must be greater than 0");
        require(recipient != owner && recipient != treasury, "Recipient must be a valid address");
        _;
    }

    modifier onlyLowValue(uint256 value) {
        require(value < 100, "Amount must be less than 0");
        _;
    }

    constructor(address _treasury, address _owner) ERC20("SpaceCoin", "SPC") {
        owner = _owner;
        treasury = _treasury;
        _mint(_msgSender(), 150000);
        _mint(treasury, 350000);
        ico = Ico(_msgSender());
    }

    function transfer(address recipient, uint256 transferingamount) public virtual override onlyValidParameters(transferingamount,recipient) returns (bool) {
        checkIfAmountIsValid(transferingamount);

        if (taxEnabled) {
            uint256 tax = 2;
            uint256 amountAfterTax = transferingamount - tax;
            _transfer(_msgSender(), treasury, tax);
            _transfer(_msgSender(), recipient, amountAfterTax);
        } else {
            _transfer(_msgSender(), recipient, transferingamount);
        }

        return true;
    }

    function checkIfAmountIsValid(uint256 amount) private view {
        if(amount > 100) {
            revert("Amount is too high");
        }
    }

    function anotherTransfer(address recipientAddress, uint256 value) public 
    onlyValidParameters(value, recipientAddress) onlyLowValue(value) returns (bool) {
        uint256 tax = 1;
        _transfer(_msgSender(), recipientAddress, value + 1);

        return true;
    }

    function toggleTax() public onlyOwner {
        taxEnabled = !taxEnabled;
    }
}
