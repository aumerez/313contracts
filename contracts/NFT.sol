// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

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

  constructor() ERC721("313Proyect", "NFT") {
    baseTokenURI = "";
  }

  function mintTo(address recipient) public payable returns (uint256) {
    uint256 tokenId = currentTokenId.current();
    require(tokenId < TOTAL_SUPPLY, "Max supply reached");
    if (tokenId >= 0 && tokenId < 5) {
            require(msg.value == MINT_PRICE_1, "Transaction value did not equal the mint price");
        } else if (tokenId >= 5 && tokenId < 10) {
            require(msg.value == MINT_PRICE_2, "Transaction value did not equal the mint price");
        } else {
            require(msg.value == MINT_PRICE_3, "Transaction value did not equal the mint price");
        }

    uint sendBalance = balanceOf(recipient);
    require( sendBalance <= 10, "Exceeded the maximum allowed Minting per wallet");

    currentTokenId.increment();
    uint256 newItemId = currentTokenId.current();
    _safeMint(recipient, newItemId);
    return newItemId;
  }

  /// @dev Returns an URI for a given token ID
  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
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