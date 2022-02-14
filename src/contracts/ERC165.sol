// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC165.sol';

contract ERC165 is IERC165 {

  constructor() {
      _registerInterface(bytes4(keccak256('supportsInterface(bytes4)')));
  }

  //mapping to hold bytes4 of interfaces and status
  mapping(bytes4 => bool) private _supportedInterfaces;


 //return bool if the interface is registered or not
 function supportsInterface(bytes4 interfaceID) external override view returns (bool){
     return _supportedInterfaces[interfaceID];
 }

  //register interface
  function _registerInterface(bytes4 interfaceID) internal {
      require(interfaceID != 0xffffffff, 'Invalid interface ID');
      _supportedInterfaces[interfaceID] = true;
  }



}