// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../common/Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";


contract FundManagerUpgradeable is ERC1967Proxy {
    
    constructor(address _logic, bytes memory _data) ERC1967Proxy(_logic, _data) {}

    /**
     * @dev To upgrade the logic contract to new one
     */
    function upgradeTo(address _newImplementation) public {
       _upgradeTo(_newImplementation);
    }

    /**
     * @dev To get the address of the proxy contract
     */
    function implementation() public view returns (address impl) {
       return _implementation();
    }
}
