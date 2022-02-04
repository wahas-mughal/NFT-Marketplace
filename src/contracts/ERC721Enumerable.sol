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


    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() external view returns (uint256) {
        return _allTokens.length;
    }


    // function tokenByIndex(uint256 _index) external view returns (uint256);

    // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);


   //mint NFTs through function overriding
   function _mint(address to, uint256 tokenId) internal override(ERC721) {
       super._mint(to, tokenId);
       _addTokensToAllTokensEnumeration(tokenId);
   }

   // add every minted token to the Total Supply 
   function _addTokensToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
       _allTokens.push(tokenId);
   }

}