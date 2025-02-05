// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "src/Bank.sol";

contract BankTest is Test {
    Bank public bank;
    address public user1;

    function setUp() public {
        bank = new Bank();
        user1 = address(0x1);
    }

    function testDepositZeroAmount() public {
        vm.deal(user1, 1 ether);
        vm.prank(user1);

        // make sure the deposit will revert when the amount is 0
        vm.expectRevert("Deposit amount must be greater than 0");

        // try to deposit 0 ether, this should fail
        bank.depositETH{ value: 0 ether }();
    }

    function testDepositCustomError() public {
        vm.deal(user1, 2 ether);
        vm.prank(user1);

        // test for custom error
        vm.expectRevert(Bank.DepositAmountMustBeGreaterThanOneEther.selector);

        // try to deposit 1 ether, this should fail
        bank.depositETH2{ value: 1 ether }();
    }

    function testDepositUpdateBalance() public {
        // give user1 1 ETH
        vm.deal(user1, 1 ether);

        // mock the user1
        vm.startPrank(user1);

        // check the initial balance is 0
        assertEq(bank.balanceOf(user1), 0, "Initial balance should be 0");

        // amount = 0.5 ether
        bank.depositETH{ value: 0.5 ether }();

        // check the balance is updated
        assertEq(bank.balanceOf(user1), 0.5 ether, "Balance should be updated after deposit");

        // amount = 0.3 ether
        bank.depositETH{ value: 0.3 ether }();

        // check the balance is updated
        assertEq(bank.balanceOf(user1), 0.8 ether, "Balance should be accumulated after second deposit");

        //  stop mock
        vm.stopPrank();
    }

    function testDepositEmitsEvent() public {
        vm.deal(user1, 2 ether);
        vm.prank(user1);

        // Set expected events
        vm.expectEmit(true, false, false, true);
        // mock the event
        emit Bank.Deposit(user1, 1 ether);

        // execute the deposit operation
        bank.depositETH{ value: 1 ether }();
    }
}
