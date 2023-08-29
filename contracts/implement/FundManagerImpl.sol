// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./handlers/RecordExpenseHandler.sol";
import "./handlers/SettleDebtsHandler.sol";

contract FundManagerImpl is RecordExpense, SettleDebt {
    /**
        @param friends: list user's address
        @param amounts: list user'amount follow friends's order
     */
    function recordExpense(
        address[] memory friends,
        uint256[] memory amounts
    ) external {

        // logic
        handleRecordExpense(friends, amounts);
    }


    /**
        @param friend: user's address
     */
    function settelDebt(address friend) external {
        //  logic

        handleSettleDebts(friend);
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
}
