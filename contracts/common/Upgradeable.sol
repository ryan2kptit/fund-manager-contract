// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

abstract contract Upgradeable is UUPSUpgradeable, AccessControlUpgradeable {
    address public implementation;

    mapping(address => int256) public balances;
    mapping(address => mapping(address => int256)) public debts; // ai no ai bao nhieu tien
    mapping(address => address[]) public creditors; // Creditors for each debtor;

    /**
        @dev Required.
     */
    function _authorizeUpgrade(address)
        internal
        virtual
        override
        onlyRole(DEFAULT_ADMIN_ROLE)
    {}
}
