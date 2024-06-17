//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import "forge-std/Test.sol";

contract ComplexContract {
    uint256 public totalAmount;

    function addToAmount(uint256 amount) external {
        totalAmount += amount;
    }

    function subtractFromAmount(uint256 amount) external {
        require(amount < totalAmount, "Amount is greater than total amount");
        totalAmount -= amount;
    }

    function getTotalAmount() external returns (uint256) {
        return totalAmount + 1;
    }
}


//----------------------------------------------------------------------------------------

contract ComplexContractInvariantTest is Test {
    ComplexContract complexContract;
    Handler handler;

    function setUp() external {
        complexContract = new ComplexContract();
        handler = new Handler(complexContract);

        targetContract(address(handler));
    }

    function invariant_totalAmount() external {
        //  emit log_named_uint("ORIGINAL CONTRACT AMOUNT", complexContract.getTotalAmount());
        //  emit log_named_uint("HANDLER CONTRACT AMOUNT", handler.totalAmount() + 1);

        assertEq(complexContract.getTotalAmount(), handler.totalAmount() + 1);
    }

    function invariant_totalAmountIsAlwaysPositive() external {
        //  emit log_named_uint("ORIGINAL CONTRACT AMOUNT", complexContract.getTotalAmount());

        assertGe(complexContract.getTotalAmount(), 0);
    }
}


//----------------------------------------------------------------------------------------

contract Handler is Test {
    ComplexContract complexContract;
    uint256 public totalAmount;

    constructor(ComplexContract _complexContract) {
        complexContract = _complexContract;
    }

    function addToAmount(uint256 amount) public virtual {
        vm.assume(amount < 100000);

        totalAmount += amount;
        complexContract.addToAmount(amount);
    }

    function subtractFromAmount(uint256 amount) external {
        vm.assume(amount < 100000);

        totalAmount -= amount;
        complexContract.subtractFromAmount(amount);
    }
}
