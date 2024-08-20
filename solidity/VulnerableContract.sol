//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract KingOfTheEtherThrone {
    struct Monarch {
        // address of the king .
        address ethAddr ;
        string name ;
        // how much he pays to previous king
        uint claimPrice ;
        uint coronationTimestamp ;
    }
    Monarch public currentMonarch ;

    // function claimThrone (string name) public {
    //     if (currentMonarch.ethAddr != wizardAddress) {
    //         currentMonarch.ethAddr.send(compensation);
    //     }
        
    //     // assign the new king
    //     currentMonarch = Monarch (
    //         msg.sender, name,
    //         valuePaid, block.timestamp);
    // }
 }