//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract ExternalContract{
    address public owner;
}

contract ComplexObjectInitialization {
    struct User {
        address addr;
        uint id;
    }

    User private owner;
    User private manager;
    ExternalContract private externalContract;

    constructor(uint creatorId, address creatorAddress, ExternalContract _externalContract){
        owner = User(creatorAddress, creatorId);
        manager = User({ addr: creatorAddress, id: creatorId });
        externalContract = _externalContract;
    }

    function isOwnerByAddress(address userAddress) public view returns(bool){
        if(owner.addr == userAddress){
            return true;
        } else {
            return false;
        }
    }

    function isOwnerById(uint id) public view returns(bool){
        if(owner.id == id){
            return true;
        } else {
            return false;
        }
    }
}

contract NestedComplexObjectInitialization {
    struct Product {
		uint price;
        Stock stock;
	}

    struct Stock
    {
        bytes16 id;
        uint quantity;
    }

    Product private product;

    constructor(uint productPrice, bytes16 storageId, uint storageQuantity){
        product = Product(productPrice, Stock(storageId, storageQuantity));
    }

    function buyProduct(uint quantity) public view returns(bool) {
        require(product.stock.quantity >= quantity, "Not enough quantity");
        return true;
    }
}