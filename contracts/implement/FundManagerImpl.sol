// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./handlers/RecordExpenseHandler.sol";
import "./handlers/SettleDebtHandler.sol";

contract FundManagerImpl is Upgradeable {
    
    function handleRecordExpense(address[] memory, uint256[] memory) external {
        // check condition

        address impl = recordExpenesHandlerAddress;
        delegateCall(impl);
    }

    
    function settelDebt(address) external {
        // check condition

        address impl = settleDebtHandlerAddress;
        delegateCall(impl);
    }

    function getDebt(address friend) external view returns (int256) {
        return balances[friend] < 0 ? balances[friend] : int256(0);
    }

    function getAllDebts(
        address debtor
    ) external view returns (address[] memory, int256[] memory) {
        address[] memory creditorList = creditors[debtor];
        int256[] memory amounts = new int256[](creditorList.length);

        for (uint256 i = 0; i < creditorList.length; i++) {
            amounts[i] = debts[debtor][creditorList[i]];
        }

        return (creditorList, amounts);
    }

    function getAllCreditors(
        address debtor
    ) internal view returns (address[] memory) {
        return creditors[debtor];
    }

    /**
     * @dev setRecordExpenesHandlerAddress
     * ** Params **
     * @param _addr address
     */
    function setRecordExpenesHandlerAddress(
        address _addr
    ) public {
        recordExpenesHandlerAddress = _addr;
    }

    /**
     * @dev setCancelHandlerAddress
     * ** Params **
     * @param _addr address
     */
    function setSettleDebtHandlerAddress(
        address _addr
    ) public {
        settleDebtHandlerAddress = _addr;
    }

    function delegateCall(address _impl) internal {
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }
}
