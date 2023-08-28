// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract BaseContract is Initializable {
    mapping(address => int256) public balances;
    mapping(address => mapping(address => int256)) public debts; // ai no ai bao nhieu tien
    mapping(address => address[]) public creditors; // Creditors for each debtor

    function initialize() public onlyInitializing {}
}
