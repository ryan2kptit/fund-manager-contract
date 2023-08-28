// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


import "../common/BaseContract.sol";

contract FundManagerUpgradeable is BaseContract {

    function initialize() public initializer {
        BaseContract.initialize(); // Do not forget this call!
    }
}
