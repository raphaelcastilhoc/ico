//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract ExternalStructExternalContract {
    struct InternalStruct {
        uint number;
    }

    struct MainStruct {
        InternalStruct internalStruct;
        bool isEnabled;
    }
}