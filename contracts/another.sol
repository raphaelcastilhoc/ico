//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract DeepInheritanceContract {
	bool public isEnabled;
	constructor(bool _isEnabled) {
		isEnabled = _isEnabled;
	}
}

contract InheritanceContract is DeepInheritanceContract {
	address public owner;
	constructor(bool _isEnabled, address _owner) DeepInheritanceContract(_isEnabled) {
		owner = _owner;
	}
}

contract AnotherInheritanceContract {
	bytes16 public ownerId;
	constructor(bytes16 _ownerId) {
		ownerId = _ownerId;
	}
}

contract SubContract is InheritanceContract, AnotherInheritanceContract {
	constructor(address _owner, bytes16 ownerId, bool _isEnabled) InheritanceContract(_isEnabled, _owner) AnotherInheritanceContract(ownerId) {
	}

	function addressOnInheritanceContract(address user) public view returns (bool) {
		if (user == owner) {
			return true;
		}
		else {
			return false;
		}
	}

	function boolInDeepInheritanceContract() public view returns (bool) {
		if (isEnabled) {
			return true;
		}
		else {
			return isEnabled;
		}
	}

	function bytesOnNextInheritanceContract(bytes16 userId) public view returns (bool) {
		if (userId != ownerId) {
			return false;
		}
		else {
			return true;
		}
	}
}

contract InnerFunctions {
	function innerFunctionResultComparison(uint firstValue, uint secondValue) public pure returns (bool) {
		uint result = addInnerFunction(firstValue, secondValue);
		
		if(result > 100){
			return true;
		} else {
			return false;
		}
	}

	function addInnerFunction(uint _firstValue, uint _secondValue) private pure returns (uint) {
		return _firstValue + _secondValue;
	}
}