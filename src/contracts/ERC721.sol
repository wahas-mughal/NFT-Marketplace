// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is ERC165, IERC721 {



  constructor() {
      _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^keccak256('ownerOf(bytes4)')^keccak256('tranferFrom(bytes4')));
  }


   //track token ids to address
   mapping(uint256 => address) private _tokenOwner;

   //track address to token ids
   mapping(address => uint256) private _tokenOwnedCount;

   //mapping from tokenId to approved addresses
   mapping(uint256 => address) private _tokensApproval;


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

    function balanceOf(address _owner) public override view returns (uint256) {
        require(_owner != address(0), 'Error - address is invalid or zero');
        uint256 tokens = _tokenOwnedCount[_owner];
        return tokens;
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) public override view returns (address){
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


    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer

    //implementation function
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        //map token id to the address receiving the token
        require(_to != address(0), 'Error - address can not be zero');
        // tranferring address should own the token
        require(ownerOf(_tokenId) == _from, 'Error - you do not owned the token');

        //update the balance of the owner
        _tokenOwnedCount[_from] = _tokenOwnedCount[_from] - 1;
        //aupdate the balance of the receiver
        _tokenOwnedCount[_to] = _tokenOwnedCount[_to] + 1;

        //transfer token id to the receiver address
        _tokensApproval[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address  _to, uint256 _tokenId) public override {
        _transferFrom(_from, _to, _tokenId);
    }

  


}