//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./InheritanceContractWithEmptyConstructor.sol";
import "./ExternalStructExternalFile.sol";
import "./ExternalStructExternalContract.sol";

struct Person {
    uint id;
    Car car;
}

struct Car {
    uint id;
    string name;
}

contract SymbolicSamples {
    address private constant OWNER_COMPANY_ADDRESS = address(0x0123);

    address private owner = address(0x0fff);
    bool private paused = true;
    uint256 private totalBalance = 1000;
    bytes10 private ownerId = 0xffffffffffffffffffff;
    uint private defaultMinimumAmount;

    modifier isOwner(address _owner) {
        require(owner == _owner, "Not owner");
        _;
    }

    modifier isPaused(bool shouldBypassPausedValidation) {
        if(!shouldBypassPausedValidation) {
			require(!paused, "Paused");
		}
        _;
    }

    function complexObject(Person memory person) public view returns (string memory) {
        return person.car.name;
    }

    function addressStateVariableComparison(address _owner) public view isOwner(_owner) returns (uint256) {
        return totalBalance;
    }

    function addressConstantComparison(address ownerCompanyAddress) public view returns (address) {
        if(ownerCompanyAddress == OWNER_COMPANY_ADDRESS) {
            return owner;
        }

        return address(0);
    }

    function uintStateVariableComparison(uint amount) public view returns (bool) {
        if(amount > totalBalance) {
            return false;
        }

        return true;
    }

    function defaultUintStateVariableComparison(uint amount) public view returns (bool) {
        if(amount == defaultMinimumAmount) {
            return false;
        }

        return true;
    }

    function boolStateVariableComparison(bool shouldBypassPausedValidation) public view isPaused(shouldBypassPausedValidation) returns (uint256) {
        return totalBalance;
    }

    function bytesStateVariableComparison(bytes16 _ownerId) public view returns (address) {
        if(ownerId == _ownerId) {
            return owner;
        }

        return address(0);
    }

    function bytesDifferentToHardCodedValueWithDifferentBitSize(bytes16 receiverId) public pure returns(bool) {
        if(receiverId == 0xffffffffffffffffffffffffffffffff) {
			return true;
		} else {
			return false;
		}
    }

    function bytesEqualToHardCodedValue(bytes8 receiverId) public pure returns(bool) {
        if(receiverId == 0xffffffffffffffff) {
			return false;
		} else {
			return true;
		}
    }

    function bytesDifferentTo(bytes2 senderId, bytes2 receiverId) public pure returns(bool) {
        if(senderId != receiverId) {
			return true;
		} else {
			return false;
		}
    }

    function subtractOperationBeforeComparison(int first, int second, int maxValue) public pure returns(bool) {
        if(first - second >= maxValue) {
			return false;
		} else {
			return true;
		}
    }

    function divideOperationBeforeComparison(uint first, uint second, uint maxValue) public pure returns(bool) {
        if(first / second <= maxValue) {
			return false;
		} else {
			return true;
		}
    }
}

contract ConstrutorWithHardCodedValues {
    address private ownerAddress;
    bytes16 private ownerId;
    bool private paused;
    uint256 private totalBalance;

    constructor() {
        ownerAddress = address(0x0fff);
        ownerId = 0xffffffffffffffffffffffffffffffff;
        paused = true;
        totalBalance = 1000;
    }

    modifier isOwner(address owner) {
        require(ownerAddress == owner, "Not owner");
        _;
    }

    function addressStateVariableComparison(address owner) public view isOwner(owner) returns (uint256) {
        return totalBalance;
    }
}

contract ConstrutorWithParameters {
    address private ownerAddress;
    bytes16 private ownerId;
    bool private paused;
    uint256 private totalBalance;

    constructor(address _ownerAddress, bytes16 _ownerId, bool _paused, uint256 _totalBalance) {
        ownerAddress = _ownerAddress;
        ownerId = _ownerId;
        paused = _paused;
        totalBalance = _totalBalance;
    }

    modifier isOwner(address owner) {
        require(ownerAddress == owner, "Not owner");
        _;
    }

    modifier isPaused() {
        require(!paused, "Paused");
        _;
    }

    function addressStateVariableComparison(address owner) public view isOwner(owner) returns (uint256) {
        return totalBalance;
    }

    function uintStateVariableComparison(uint amount) public view returns (bool) {
        if(amount > totalBalance) {
            return false;
        }

        return true;
    }

    function boolStateVariableComparison() public view isPaused() returns (uint256) {
        return totalBalance;
    }

    function bytesStateVariableComparison(bytes16 id) public view returns (address) {
        if(ownerId == id) {
            return ownerAddress;
        }

        return address(0);
    }
}

contract InheritanceContract {
	address private owner;
	bool private isEnabled;

	constructor(bool _isEnabled, address ownerAddress) {
        isEnabled = _isEnabled;
		owner = ownerAddress;
	}

	modifier onlyOwner(address _owner) {
        require(owner == _owner, "It is not owner");
        _;
    }

	modifier whenEnabled() {
        require(isEnabled, "It is not enabled");
        _;
    }
}

contract InheritanceContractWithoutConstructor {
	uint256 internal totalBalance = 1000;
}

contract SubContract is InheritanceContract, InheritanceContractWithoutConstructor, InheritanceContractWithEmptyConstructor {
	constructor(address _owner, bool _isEnabled) InheritanceContract(_isEnabled, _owner) {

	}

	function addressStateVariableComparison(address receiver, address owner) public view onlyOwner(owner) returns (uint256) {
        return totalBalance;
    }

	function boolStateVariableComparison() public view whenEnabled() returns (uint256) {
        return totalBalance;
    }

	function uintStateVariableComparison(uint amount) public view returns (bool) {
        if(amount > totalBalance) {
            return false;
        }

        return true;
    }

	function bytesStateVariableComparison(bytes8 _id) public view returns (bool) {
        if(_id == id) {
            return true;
        }

        return false;
    }
}

contract InheritedSpecialVariableComparison {
	address private owner;

	constructor() {
		owner = msg.sender;
	}

	modifier isOwner() {
        require(msg.sender == owner, "Sender is not owner");
        _;
    }
}

contract SpecialVariableComparison is InheritedSpecialVariableComparison {
	function msgSenderEqualToStateVariable() isOwner public view returns(bool) {
        return true;
    }
}

struct ExternalStruct {
    uint number;
}

contract StructComparison {
    struct InternalStruct {
        uint number;
    }

    function externalStructUintComparison(ExternalStruct memory externalStruct) public view returns(bool) {
        if(externalStruct.number >= 100) {
            return true;
        }

        return false;
    }

    function internalStructUintComparison(InternalStruct memory internalStruct) public view returns(bool) {
        if(internalStruct.number > 200) {
            return true;
        }

        return false;
    }

    function externalStructExternalFileUintComparison(ExternalStructExternalFile memory externalStructExternalFile) public view returns(bool) {
        if(externalStructExternalFile.number > 200) {
            return true;
        }

        return false;
    }

    function externalStructExternalContractUintComparison(ExternalStructExternalContract.MainStruct memory externalMainStructExternalContract) public view returns(bool) {
        if(externalMainStructExternalContract.internalStruct.number > 200 && externalMainStructExternalContract.isEnabled) {
            return true;
        }

        return false;
    }

    function addressAssignmentLocalVariableBeforeComparison(address receiver) public view returns(bool) {
		address _receiver = receiver;
		if(_receiver == msg.sender) {
			return false;
		} else {
			return true;
		}
	}

    function intDeclararionAndAssignmentSeparateVariableBeforeComparison(int id) public view returns(bool) {
		int _id;
        _id = id;
		if(_id == 0) {
			return false;
		} else {
			return true;
		}
	}

    function sample(address receiver) public view returns(bool) {
		bool result = addressAssignmentLocalVariableBeforeComparison(receiver);
		if(result) {
			return true;
		} else {
			return false;
		}
	}

    function msgValueLessThanParameter(uint valueToTransfer) public payable returns(bool) {
        if(msg.value < valueToTransfer) {
			return false;
		} else {
			return true;
		}
    }
}

contract InheritanceContract2 {
	struct User {
		bytes16 id;
		address _address;
	}

	User owner;

	constructor(User memory _owner) {
		owner = _owner;
	}
}

contract ConstructorWithStructParameters is InheritanceContract2 {
    constructor(InheritanceContract2.User memory _owner) InheritanceContract2(_owner) {
	}

    function structStateVariableComparison(InheritanceContract2.User memory user) public view returns (bool) {
        if (owner.id == user.id || owner._address == user._address) {
			return true;
		} else {
			return false;
		}
    }
}