// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../../common/Upgradeable.sol";

abstract contract SettleDebtHandler is Upgradeable {
    event DebtsSettled(
        address indexed payer,
        address indexed friend,
        uint256 amount
    );

    /**
     * @param _friend: user's address
     */
    function handleSettleDebts(address _friend) internal {
        require(balances[_friend] < 0, "No debt to settle");
        int256 debt = balances[_friend] * -1;
        balances[msg.sender] -= debt;
        balances[_friend] = 0;
        // usdtToken.transfer(_friend, uint256(debt));

        debts[msg.sender][_friend] = 0; // Reset the debt relationship

        address[] storage debtorCreditors = creditors[msg.sender];
        for (uint256 i = 0; i < debtorCreditors.length; i++) {
            if (debtorCreditors[i] == _friend) {
                debtorCreditors[i] = debtorCreditors[
                    debtorCreditors.length - 1
                ];
                debtorCreditors.pop();
                break;
            }
        }

        emit DebtsSettled(msg.sender, _friend, uint256(debt));
    }
}
