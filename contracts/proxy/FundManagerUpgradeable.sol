// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../common/Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract FundManagerUpgradeable is UUPSUpgradeable, AccessControlUpgradeable {

    function initialize() public initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /**
     * @dev To upgrade the logic contract to new one
     */
    function upgradeTo(address _newImplementation) override public onlyRole(DEFAULT_ADMIN_ROLE){
        _upgradeTo(_newImplementation);
    }

    /**
     * @dev To get the address of the proxy contract
     */
    function implementation() public view returns (address impl) {
        return _getImplementation();
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
