// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFT is ERC721, PullPayment, Ownable {
  using Counters for Counters.Counter;

    // Constants
  uint256 public constant TOTAL_SUPPLY = 7_777;
  uint256 public constant MINT_PRICE_1 = 0.00 ether;
  uint256 public constant MINT_PRICE_2 = 0.0313 ether;
  uint256 public constant MINT_PRICE_3 = 0.06 ether;

  Counters.Counter private currentTokenId;

  /// @dev Base token URI used as a prefix by tokenURI().
  string public baseTokenURI;
  string private errorMessage  = "There are not NFTs available at that price, you can only buy ";

  constructor() ERC721("313Proyect", "NFT") {
    baseTokenURI = "";
  }

  function mintTo(address recipient, uint256 num) public payable returns (uint256) {
    uint256 tokenId = currentTokenId.current();

    uint256 newItemId = 0;

    if (tokenId <= 5 && tokenId + num > 6) {
        require(newItemId != 0, string(abi.encodePacked(errorMessage, Strings.toString(5-num), " NFTs")));
    } else if (tokenId <= 10 && tokenId + num > 11) {
        require(newItemId != 0, string(abi.encodePacked(errorMessage, Strings.toString(10-num), " NFTs")));
    }

    if (tokenId >= 0 && tokenId <= 5) {
              require(msg.value == MINT_PRICE_1 * num, "Transaction value did not equal the mint price");
          } else if (tokenId > 5 && tokenId < 10) {
              require(msg.value == MINT_PRICE_2 * num, "Transaction value did not equal the mint price");
          } else {
              require(msg.value == MINT_PRICE_3 * num, "Transaction value did not equal the mint price");
          }

    for (uint i = 0; i < num; i++) {
      require(tokenId < TOTAL_SUPPLY, "Max supply reached");
      
      uint sendBalance = balanceOf(recipient);
      require( sendBalance <= 7, "Exceeded the maximum allowed Minting per wallet");

      currentTokenId.increment();
      newItemId = currentTokenId.current();
      _safeMint(recipient, newItemId);    
    }

    return newItemId;
  }

  /// @dev Returns an URI for a given token ID
  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  /// @dev Returns an current token ID
  function _currentId() internal view virtual returns (uint256) {
    return currentTokenId.current();
  }

  /// @dev Sets the base token URI prefix.
  function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
    baseTokenURI = _baseTokenURI;
  }

  /// @dev Overridden in order to make it an onlyOwner function
  function withdrawPayments(address payable payee) public override onlyOwner virtual {
      super.withdrawPayments(payee);
  }
}