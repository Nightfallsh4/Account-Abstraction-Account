// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts-upgradeable/contracts/access/AccessControlEnumerableUpgradeable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

contract AaWallet is Initializable, UUPSUpgradeable, AccessControlEnumerableUpgradeable{
    uint256 private s_nonce = 0;

    address private s_entryPoint;
    address private s_owner;
    address[] private s_guardians;


    bytes32 constant private GUARDIAN_ROLE = keccak256("GUARDIAN_ROLE");
    bytes32 constant private SPENDER_ROLE = keccak256("SPENDER_ROLE");

    struct UserOperation {
        address sender;
        uint256 nonce;
        bytes initCode;
        bytes callData;
        uint256 callGasLimit;
        uint256 verificationGasLimit;
        uint256 preVerificationGas;
        uint256 maxFeePerGas;
        uint256 maxPriorityFeePerGas;
        bytes paymasterAndData;
        bytes signature;
    }

    // Modifiers


    function initialize(address _owner, address _entryPoint, address[] memory _guardians) initializer public  {
        require(_owner != address(0),"Owner cannot be zero address");
        require(_entryPoint != address(0),"Entry Point Cannot be zero");
        _grantRole(DEFAULT_ADMIN_ROLE, address(0));
        _grantRole(SPENDER_ROLE, _owner);
        _grantRole(SPENDER_ROLE, _entryPoint);
        s_entryPoint = _entryPoint;
        s_owner = _owner;
        for (uint256 index = 0; index < _guardians.length; index++) {
            _grantRole(GUARDIAN_ROLE, _guardians[index]);
        }
        s_guardians = _guardians;
        __UUPSUpgradeable_init();
        __AccessControlEnumerable_init();
    }

    function _authorizeUpgrade(address newImplementation) onlyRole(SPENDER_ROLE) internal override{}

   
    function validateUserOp(UserOperation calldata userOp, bytes32 userOpHash, address aggregator, uint256 missingAccountFunds) 
        external returns (uint256 sigTimeRange) {

    }

    function nonce() public view returns (uint256){
        return s_nonce;
    }

    function entryPoint() public view returns (address) {
        return s_entryPoint;
    }

    function owner() public view returns (address) {
        return s_owner;
    }

    function guardians() public view returns (address[] memory) {
        return s_guardians;
    }
    
}