// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";

import "src/AaWallet.sol";

contract AaWalletTest is Test {
    AaWallet private walletContract;
    address private owner = address(1);
    address private entryPoint = address(2);
    address[] guardians = [address(5), address(6), address(7)];
    bytes32 constant private SPENDER_ROLE = keccak256("SPENDER_ROLE");
    bytes32 constant private GUARDIAN_ROLE = keccak256("GUARDIAN_ROLE");

    function setUp() public {    
        walletContract = new AaWallet(owner, entryPoint, guardians);
    }

    function testFail_Constructor_RevertsWhenOwnerIsZero() public {
        new AaWallet(address(0), entryPoint, guardians);
    }

    function testFail_Constructor_RevertsWhenEntryPointIsZero() public {
        new AaWallet(owner, address(0), guardians);
    }

    function test_Constructor_DefaultAdminSetToZero() public {
        bytes32 role = 0x00;
        bool hasRole = walletContract.hasRole(role, address(0));
        assertEq(hasRole, true);
    }

    function test_Constructor_OwnerHasSpenderRole() public {
        bool isRole = walletContract.hasRole(SPENDER_ROLE, owner);
        assertEq(isRole, true);
    }

    function test_Constructor_EntryPointHasSpenderRole() public {
        bool isRole = walletContract.hasRole(SPENDER_ROLE, entryPoint);
        assertEq(isRole, true);
    }

    function test_Constructor_OwnerEntryPointGuardiansSetCorrectly() public {
        address _owner = walletContract.owner();
        address _entryPoint = walletContract.entryPoint();
        address[] memory _guardians = walletContract.guardians();
        assertEq(_owner, owner);
        assertEq(_entryPoint, entryPoint);
        assertEq(_guardians, guardians);
    }

    function test_Constructor_GuardianRoleSetCorrectly() public {
        bool isRole1 = walletContract.hasRole(GUARDIAN_ROLE, guardians[0]);
        bool isRole2 = walletContract.hasRole(GUARDIAN_ROLE, guardians[1]);
        bool isRole3 = walletContract.hasRole(GUARDIAN_ROLE, guardians[2]);
        assertEq(isRole1, true);
        assertEq(isRole2, true);
        assertEq(isRole3, true);
    }
}