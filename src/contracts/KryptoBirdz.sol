// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector { 

   //create a string array to store NFTS already minted
   string[] public kryptoBirds; 

   //track the minted NFTs
   mapping(string => bool) _kryptoBirdsExists;

    //mint function to mint ntfs
    function mint(string memory _kryptoBird) public {
       
        //check if a kryptoBird exists or not
        require(!_kryptoBirdsExists[_kryptoBird], "Error - kryptoBird already exists!");
        
        //push the NFT to the string array
        kryptoBirds.push(_kryptoBird);
        uint256 _id = kryptoBirds.length - 1;

        //call the _mint function
        _mint(msg.sender, _id);

        //keep track of the minted NFTs
        _kryptoBirdsExists[_kryptoBird] = true;
    }

    constructor() ERC721Connector('KryptoBirdz', 'KBIRDZ') {
    }
}