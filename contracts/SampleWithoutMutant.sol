//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract SampleWithoutMutant  {
    event SomethingHappened(address sender, string text);

    function logText(string memory text) public {
        emit SomethingHappened(msg.sender, text);
    }
}