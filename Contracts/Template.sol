// SPDX-License-Identifier: MIT
pragma solidity^ 0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract NFT is ERC721,Ownable{
    uint256 public constant MAX_TOKENS = 56;
    uint256 private constant TOKENS_RESERVED = 300;
    uint256 public price = 900;
    uint256 public constant MAX_MINT_PER_TOKEN = 5;

    bool public saleActive;
    uint256 public totalSupply;
    mapping(address=> uint256) private mintedWallet;

    string public baseUri;
    string public baseExtension = ".json";

    constructor() ERC721("NFT name", "Symbol"){
        baseUri = ""; //image
        for (uint256 i = 1; i<= TOKENS_RESERVED; ++i){
            _safeMint(msg.sender, i);
        }
        totalSupply = TOKENS_RESERVED;
    }

    function mint(uint256 _numTokens) external payable {
        require(saleActive,"The sale is paused");
        require(_numTokens <= MAX_MINT_PER_TOKEN, "You can only mint a max of 5 tokens per transaction");
        require(mintedWallet[msg.sender] + _numTokens <= 5, "You can only mint 5 per wallet");
        uint256 curTotalSupply = totalSupply;
        require(_numTokens * price <= msg.value, "Insufficient balance");

        for (uint256 i = 1; i <= _numTokens; ++i){
            _safeMint(msg.sender, curTotalSupply + i);
        }
        mintedWallet[msg.sender] += _numTokens;
        totalSupply += _numTokens;
    }

    function saleState() external onlyOwner{
        saleActive = !saleActive;
    }

    function setBaseURI(string memory _baseURI) external onlyOwner{
        baseUri = _baseURI;
    }

    function setPrice(uint256 _price) external onlyOwner{
        price = _price;
    }

    function withdrawAll() external payable onlyOwner{
        uint256 balance = address(this).balance;
        uint256 balance1 = balance * 70/100;
        uint256 balance2 = balance * 30/100;
        (bool transfer1, ) = payable().call{value: balance1}("");
        (bool transfer2, ) = payable().call{value: balance2}("");
        require(transfer1 && transfer2, "Transfer failed.");
    }

    function tokenURI(uint256 tokenId) public view returns(string memory){
        require(
            _exists(tokenId),
            "ERC721Metadata: Token does not exist"
        );

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
    }

    function _baseURI() internal view virtual returns (string memory){
        return baseUri;
    }

}