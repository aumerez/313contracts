//import Open Zepplin contracts

pragma solidity ^0.8.2;

//import Open Zepplin contracts
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFT is ERC721 {
    uint256 private _tokenIds;
    
    constructor() ERC721("Name", "Symbol") {}
    
//use the mint function to create an NFT
    function mint()
    public
    returns (uint256)
    {
        _tokenIds += 1;
        _mint(msg.sender, _tokenIds);
        return _tokenIds;
    }
    
//in the function below include the CID of the JSON folder on IPFS
    function tokenURI(uint256 _tokenId) override public pure returns(string memory) {
        return string(
            abi.encodePacked(
                "https://ipfs.io/ipfs/QmehAeNkXqCyy62P9AhxrhyiNWMuuofWHcW4jVaAMDQsSv/",
                Strings.toString(_tokenId),
                ".json"
            )
        );
    }
}