// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/utils/Address.sol";

contract Bank {
    // custom error
    error DepositAmountMustBeGreaterThanOne();

    mapping(address => uint256) public balanceOf;

    event Deposit(address indexed user, uint256 amount);

    function depositETH() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // test for custom error
    function depositETH2() external payable {
        if (msg.value <= 1 ether) {
            revert DepositAmountMustBeGreaterThanOne();
        }
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
}
