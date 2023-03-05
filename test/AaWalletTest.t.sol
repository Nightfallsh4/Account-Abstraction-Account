// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";

import "src/AaWallet.sol";
import "src/AaWalletProxy.sol";

contract AaWalletTest is Test {
    AaWallet private walletContract;
    AaWallet private walletContractImplementation;
    address private owner = address(1);
    address private entryPoint = address(2);
    address[] guardians = [address(5), address(6), address(7)];
    bytes32 private constant SPENDER_ROLE = keccak256("SPENDER_ROLE");
    bytes32 private constant GUARDIAN_ROLE = keccak256("GUARDIAN_ROLE");

    function setUp() public {
        walletContractImplementation = new AaWallet();
        address payable walletContractAddress = payable(address(new AaWalletProxy(
            address(walletContractImplementation),
            abi.encodeWithSelector(
                walletContractImplementation.initialize.selector,
                owner, entryPoint, guardians
            )
        )));
        walletContract = AaWallet(walletContractAddress);
        // walletContract.initialize(owner, entryPoint,guardians);
    }

    function testFail_Initializer_RevertsWhenOwnerIsZero() public {
        new AaWalletProxy(
            address(walletContractImplementation),
            abi.encodeWithSelector(
                walletContractImplementation.initialize.selector,
                address(0), entryPoint, guardians
            )
        );
    }

    function testFail_Initializer_RevertsWhenEntryPointIsZero() public {
        new AaWalletProxy(
            address(walletContractImplementation),
            abi.encodeWithSelector(
                walletContractImplementation.initialize.selector,
                owner, address(0), guardians
            )
        );
    }

    function test_Initializer_DefaultAdminSetToZero() public {
        bytes32 role = 0x00;
        bool hasRole = walletContract.hasRole(role, address(0));
        assertEq(hasRole, true);
    }

    function test_Initializer_OwnerHasSpenderRole() public {
        bool isRole = walletContract.hasRole(SPENDER_ROLE, owner);
        assertEq(isRole, true);
    }

    function test_Initializer_EntryPointHasSpenderRole() public {
        bool isRole = walletContract.hasRole(SPENDER_ROLE, entryPoint);
        assertEq(isRole, true);
    }

    function test_Initializer_OwnerEntryPointGuardiansSetCorrectly() public {
        address _owner = walletContract.owner();
        address _entryPoint = walletContract.entryPoint();
        address[] memory _guardians = walletContract.guardians();
        assertEq(_owner, owner);
        assertEq(_entryPoint, entryPoint);
        assertEq(_guardians, guardians);
    }

    function test_Initializer_GuardianRoleSetCorrectly() public {
        bool isRole1 = walletContract.hasRole(GUARDIAN_ROLE, guardians[0]);
        bool isRole2 = walletContract.hasRole(GUARDIAN_ROLE, guardians[1]);
        bool isRole3 = walletContract.hasRole(GUARDIAN_ROLE, guardians[2]);
        assertEq(isRole1, true);
        assertEq(isRole2, true);
        assertEq(isRole3, true);
    }
}
