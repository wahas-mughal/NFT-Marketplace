// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 {


    //emit event
    event Transfer(
    address indexed from, 
    address indexed to, 
    uint256 indexed tokenId);

   //track token ids to address
   mapping(uint256 => address) private _tokenOwner;

   //track address to token ids
   mapping(address => uint256) private _tokenOwnedCount;


  //check whether the token exists or not
  function _exist(uint256 tokenId) view internal returns(bool) {
      //get the address again the tokenId
      address owner = _tokenOwner[tokenId];
      //return true or false based on the condition
      return owner != address(0);
  }
  
  //minting the tokens
   function _mint(address to, uint256 tokenId) internal {
       //minting should not be zero
       require(to != address(0), 'ERC721: minting to zero address'); 
       //token should not exist before
       require(_exist(tokenId), 'ERC721: token should not already exist');
       //setting the address to the tokenId
       _tokenOwner[tokenId] = to;
       //increasing the token count to the address
       _tokenOwnedCount[to] = _tokenOwnedCount[to] + 1; 
       //emit the event
       emit Transfer(address(0), to, tokenId);
   }



}