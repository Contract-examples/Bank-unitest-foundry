// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "src/Bank.sol";

contract BankTest is Test {
    Bank public bank;
    address public admin;
    address public user1;
    address public user2;
    address public user3;

    function setUp() public {
        bank = new Bank();
        user1 = address(0x1);
        user2 = address(0x2);
        user3 = address(0x3);
    }

    function testDepositZeroAmount() public {
        vm.deal(user1, 1 ether);
        vm.prank(user1);

        // make sure the deposit will revert when the amount is 0
        vm.expectRevert("Deposit amount must be greater than 0");

        // try to deposit 0 ether, this should fail
        bank.depositETH{ value: 0 ether }();
    }

    function testDepositUpdateBalance() public {
        // give user1 1 ETH
        vm.deal(user1, 1 ether);

        // check the initial balance is 0
        assertEq(bank.balanceOf(user1), 0, "Initial balance should be 0");

        // amount = 0.5 ether 
        vm.prank(user1);
        bank.depositETH{ value: 0.5 ether }();

        // check the balance is updated 
        assertEq(bank.balanceOf(user1), 0.5 ether, "Balance should be updated after deposit");

        // amount = 0.3 ether   
        vm.prank(user1);
        bank.depositETH{ value: 0.3 ether }();

        // check the balance is updated
        assertEq(bank.balanceOf(user1), 0.8 ether, "Balance should be accumulated after second deposit");
    }
}
