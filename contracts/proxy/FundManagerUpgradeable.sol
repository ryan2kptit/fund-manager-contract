// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../common/Upgradeable.sol";

contract FundManagerUpgradeable is Upgradeable {
    function initialize() public initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function setFundManagerImpl(
        address newFundManagerImpl
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        implementation = newFundManagerImpl;
    }

    function recordExpense(
        address[] memory,
        uint256[] memory 
    ) external {
        delegatecall(implementation);
    }

    function settelDebt(address) external {
        delegatecall(implementation);
    }

    // function getDebt(address friend) external view returns (int256) {
    //     _delegate(implementation);
    // }

    // function getAllDebts(
    //     address debtor
    // ) external view returns (address[] memory, int256[] memory) {
    //     _delegate(implementation);
    // }

    // function getAllCreditors(
    //     address debtor
    // ) internal view returns (address[] memory) {
    //     _delegate(implementation);
    // }

    function delegatecall(address implementation) internal virtual {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}
