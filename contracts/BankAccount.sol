// SPDX-License-Identifier: None
pragma solidity ^0.8.0;

contract BankAccount {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        if (balances[msg.sender] >= amount) {
            (bool success,) = msg.sender.call{value: amount}("");
            if (success) {
                balances[msg.sender] -= amount;
            }
        }
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}