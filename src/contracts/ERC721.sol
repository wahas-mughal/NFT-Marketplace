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
  

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero

    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), 'Error - address is invalid or zero');
        uint256 tokens = _tokenOwnedCount[_owner];
        return tokens;
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) external view returns (address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Error - token does not exist!');
        return owner;
    } 


  
  //minting the tokens
   function _mint(address to, uint256 tokenId) internal virtual {
       //minting should not be zero
       require(to != address(0), 'ERC721: minting to zero address'); 
       //token should not exist before
       require(!_exist(tokenId), 'ERC721: token should not already exist');
       //setting the address to the tokenId
       _tokenOwner[tokenId] = to;
       //increasing the token count to the address
       _tokenOwnedCount[to] = _tokenOwnedCount[to] + 1; 
       //emit the event
       emit Transfer(address(0), to, tokenId);
   }



}