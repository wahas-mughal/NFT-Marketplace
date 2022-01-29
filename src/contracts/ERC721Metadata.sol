// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721Metadata {

    string private _name;
    string private _symbol;

    constructor(string memory named, string memory sign){
        _name = named;
        _symbol = sign;
    }

    //returns name
    function name() external view returns(string memory)  {
        return _name;
    }
    
    //returns symbol
   function symbol() external view returns(string memory)  {
        return _symbol;
    }

}