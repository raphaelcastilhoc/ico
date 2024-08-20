//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract DeeperExternalContractStateVariableInheritance {
	int public maxValue = 5000;
}

contract ExternalContractStateVariableInheritance is DeeperExternalContractStateVariableInheritance {
	bytes16 public ownerId = 0xffffffffffffffffffffffffffffffff;
	int internal minValue = 1000;

	function validateMinValue(int value) external view returns (bool) {
		if(value > minValue){
			return true;
		}

		return false;
	}
}

contract ExternalContractStateVariable is ExternalContractStateVariableInheritance {
    uint256 public balance = 100;
    address public owner = address(0x0fff);

	function isBalanceEnough(uint256 value) external returns (bool) {
		if(value <= balance){
			return true;
		}

		return false;
	}

	function isOwnerId(bytes16 senderId) external returns (bool) {
		if(senderId == ownerId){
			return true;
		}

		return false;
	}
}