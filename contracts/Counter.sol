// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter {
    uint public count;
    string public name;

    function increment() public {
        count += 1;
    }

    function getCount() public view returns (uint) {
        return count;
    }

    function incrementNumber(uint number) public {
        count += number;
    }

    function updateDetails(uint updatedCount, string memory updatedName) public returns (bool) {
        if(updatedCount > 10) {
            name = updatedName;
            count = updatedCount;

            return true;
        }
        else {
            return false;
        }
    }
}