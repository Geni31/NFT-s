// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract Azuki is ERC721A {
    constructor() ERC721A("Animals", "ANI") {}

    function mint(uint256 quantity) external payable {
        // _mint's second argument now takes in a quantity, not a tokenId.
        _mint(msg.sender, quantity);
    }
    
    
    function _baseURI() internal view virtual override  returns (string memory) {
        return "ipfs://QmeUNntDiQGrkR6Fw2eYUvssGdq9bew3UoHkYBpKpTptai/";
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json"));
    }
    
}
