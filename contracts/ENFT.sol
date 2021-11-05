// contracts/ENFT.sol
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract ENFT is ERC721URIStorage , Ownable{
    
    event NFTCreated (
      uint256 indexed nftId,
      string name,
      string description,
      uint256 price,
      string image,
      address payable seller,
      address payable owner,
      bool isSold
   );
  
   event NftSold(uint256 nftId, address indexed buyer, uint256 price);
   
   modifier SaleNftItem(uint256 Id) {
       require(nfts[Id].isSold == false, "not again buying nft item");
       _;
   }
  
   struct NFT {
        uint256 nftId;
        string name;
        string description;
        uint256 price;
        string image;
        address payable seller;
        address payable owner;
        bool isSold;
    }
    
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIds;


    mapping(uint256 => NFT) public nfts;
    mapping(address => uint) private balances;
    mapping(uint256 => address) private NftOwners;
    mapping(address => mapping (address => uint256)) allowed;
    
    address payable _owner;

    constructor() ERC721("ENFT", "ENFT") {  
       _owner = payable(msg.sender);
    }

    function balanceOf(address owner) public virtual override view returns (uint balance)
     {
        return balances[owner];
     }
     
    function totalSupply() public view returns (uint256) 
     {
        return _tokenIds.current();
     }

    function approve(address _to, uint256 nftId) public virtual override 
     {
        require(msg.sender == ownerOf(nftId));
        require(msg.sender != _to);
        allowed[msg.sender][_to] = nftId;
        emit Approval(msg.sender, _to, nftId);
     }
     
    function mintNft(string memory tokenUR, string memory name, string memory description, uint256 price, string memory image) external onlyOwner returns (uint256) 
     {
        require(_owner == msg.sender);
        require(price > 0);

        uint256 newNftTokenId = _tokenIds.current();
        _safeMint(msg.sender, newNftTokenId);
        _setTokenURI(newNftTokenId, tokenUR);
        
        nfts[newNftTokenId] = NFT(newNftTokenId, name, description, price, image, payable(msg.sender), payable(address(this)), false);
        NftOwners[newNftTokenId] = msg.sender;
        _tokenIds.increment();
        emit NFTCreated(newNftTokenId, name, description, price, image, payable(msg.sender), payable(address(this)) , false);
        return newNftTokenId;                                      
     }
    

     function getNftItem(uint256 nftId) external view returns (uint256 id, string memory name, string memory description, uint256 price, string memory image, address seller, address owner, bool isSold) 
       {
         require(_exists(nftId), "token not minted");
         NFT storage nft = nfts[nftId];
         id = nft.nftId;
         name = nft.name;
         description = nft.description;
         price = nft.price;
         image = nft.image;
         seller = nft.seller;
         owner =  nft.owner;
         isSold = nft.isSold;
       }
     
      function SaleNft(uint256 nftId) public payable SaleNftItem(nftId)
       {
            uint price = nfts[nftId].price;
            require(msg.value == price, "Please submit the asking price in order to complete the purchase");
            nfts[nftId].seller.transfer(msg.value);
            nfts[nftId].owner = payable(msg.sender);
            nfts[nftId].isSold = true;
            emit NftSold(nftId, msg.sender, nfts[nftId].price);
       }
    
      function ownerOfNft(uint256 nftId) public  view returns (address owner) 
       {
        require(_exists(nftId));
        return NftOwners[nftId];
       }
    
}
