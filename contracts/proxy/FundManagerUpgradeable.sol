// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../common/Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract FundManagerUpgradeable is UUPSUpgradeable, AccessControlUpgradeable {
    bytes32 private constant implementationPosition =
        keccak256("implementation.contract:2023");

    function initialize() public initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

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
