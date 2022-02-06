// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumerable is ERC721 {


    //keep track of all minted tokens
    uint256[] private _allTokens;

    // map token id to token indexes
    mapping(uint256 => uint256) private _allTokensIndex;
    //map owner adress to the list of token ids i.e. token collection
    mapping(address => uint256[]) private _ownedTokens;
    //map token id to the index of the owned token list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    //total supply of minted tokens
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    
    //get token by index
    function tokenByIndex(uint256 _index) external view returns (uint256) {
        require(_index < totalSupply(), 'globle index is out of bound');
        return _allTokens[_index];
    }


    //get token by owner address and index
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
        require(_index < balanceOf(_owner), 'owner index is out of bound');
        return _ownedTokens[_owner][_index];
    }


   //mint NFTs through function overriding
   function _mint(address to, uint256 tokenId) internal override(ERC721) {
       super._mint(to, tokenId);
       _addTokensToAllTokensEnumeration(tokenId);
       _addTokensToOwnersEnumeration(to, tokenId);
   }

   //add ownedTokens to the owner addresses
   function _addTokensToOwnersEnumeration(address to, uint256 tokenId) private {
       //asign the tokenId to the address index 
       _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
       //push tokenId into the array with the address
       _ownedTokens[to].push(tokenId);
   }

   // add every minted token to the Total Supply 
   function _addTokensToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
       _allTokens.push(tokenId);
   }

}