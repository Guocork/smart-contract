// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

library Address {
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }
}
