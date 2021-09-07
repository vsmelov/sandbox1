// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./ERC20PresetOwnablePausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract A {
    uint256 immutable public value;
    uint256 public other;
    constructor (uint256 _value) {
        value = _value;
    }
    function stub(uint256 x) external {
        other = x*value;
    }
}

contract B {
    uint256 public value;
    uint256 public other;
    constructor (uint256 _value) {
        value = _value;
    }
    function stub(uint256 x) external {
        other = x*value;
    }
}
