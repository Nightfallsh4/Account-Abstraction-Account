// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract AaWalletProxy is ERC1967Proxy {

    constructor(address _implementationAddress, bytes memory data) ERC1967Proxy(_implementationAddress,data) {

    }
}