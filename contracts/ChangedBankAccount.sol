// SPDX-License-Identifier: None
pragma solidity ^0.8.0;

contract ChangedBankAccount {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        if (balances[msg.sender] >= amount) {
            balances[msg.sender] -= amount;
            // (bool success,) = msg.sender.call{value: amount}("");
            // if (success) { // opix-target-branch-16-False
            //     balances[msg.sender] -= amount;
            // } else { // opix-target-branch-16-YOUR-TEST-SHOULD-ENTER-THIS-ELSE-BRANCH-BY-MAKING-THE-PRECEDING-IFS-CONDITIONS-FALSE
            //     assert(true);
            // }
        } else {
            assert(true);
        }
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}
