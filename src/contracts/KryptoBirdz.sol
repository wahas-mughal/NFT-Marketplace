// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract Kryptobird is ERC721Connector { 

   //create a string array to store NFTS already minted
   string[] public kryptoBirds; 

    //mint function to mint ntfs
    function mint(string memory _kryptoBird) public {
        kryptoBirds.push(_kryptoBird);
        uint256 _id = kryptoBirds.length - 1;
        _mint(msg.sender, _id);
    }

    constructor() ERC721Connector('KryptoBirdz', 'KBIRDZ') {
    }
}