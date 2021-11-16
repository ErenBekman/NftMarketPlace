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
      uint256 indexed userId,
      string name,
      string description,
      uint256 price,
      string image,
      address payable seller,
      address payable newowner,
      bool isSold
   );
  
   event NftSold(uint256 nftId, uint256  userId, address indexed buyer, uint256 price, bool isSold);
   event UserRegister(uint256 userId, address indexed userAddr, string username, string password, string bio, uint ubalance);
   
   modifier SaleNftItem(uint256 nftId) {
       require(nfts[nftId][_userId].isSold == false, "not again buying nft item");
       _;
   }
   
    modifier onlyApproved {
       require(users[nftItemOwner].isUserLoggedIn == true, "You are not registered.");
        _;
    }

       
    modifier nftOwner(uint256 Id) {
       require(NftOwners[Id] == msg.sender, "You are not owner.");
        _;
    }
  
    struct NFT {
        uint256 nftId;
        uint256 userId;
        string name;
        string description;
        uint256 price;
        string image;
        address payable seller;
        address payable newowner;
        bool isSold;
     }
     

     struct User {
        uint id;
        address addr;
        string username;
        string password;
        string bio;
        uint ubalance;
        bool isUserLoggedIn;
    }
    
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIds;


    mapping(uint256 => mapping(uint256 => NFT)) public nfts;
    mapping(uint256 => NFT) public allnfts;
    mapping(uint256 => address) private NftOwners;
    mapping(address => mapping (address => uint256)) allowed;
    mapping(address => User) public users;
        
    uint256 public _userId;
    address public nftItemOwner;
    address public nftownaddr;

    constructor() ERC721("ENFT", "ENFT") {  

    }


    
    function getBalance(address owner) public view returns(uint accountBalance)
    {
       accountBalance = owner.balance;
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
     
     function transferOwnership(address newOwner) public override {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
         nftItemOwner = newOwner;
    }
     

    function mintNft(string memory tokenUR, string memory name, string memory description, uint256 price, string memory image) external onlyApproved returns (uint256) 
     {
        // require(_owner == msg.sender);
        require(price > 0);

        uint256 newNftTokenId = _tokenIds.current();
        _safeMint(msg.sender, newNftTokenId);
        _setTokenURI(newNftTokenId, tokenUR);
        
        nfts[newNftTokenId][_userId] = NFT(newNftTokenId, _userId, name, description, price, image, payable(msg.sender), payable(address(this)), false);
        allnfts[newNftTokenId] = NFT(newNftTokenId, _userId, name, description, price, image, payable(msg.sender), payable(address(this)), false);
        NftOwners[newNftTokenId] = msg.sender;
        nftItemOwner = msg.sender;
        _tokenIds.increment();
        emit NFTCreated(newNftTokenId, _userId, name, description, price, image, payable(msg.sender), payable(address(this)) , false);
        return newNftTokenId;                                      
     }
    

     function getNftItem(uint256 nftId, uint256 useridd) external view returns (uint256 id, uint256 userid,string memory name, string memory description, uint256 price, string memory image, address seller, address newowner, bool isSold) 
       {
         require(_exists(nftId), "token not minted");
         require(useridd == _userId, "user id  not minted");
        //  require(_userid == userId, "userid mistake");
        //  require(NftOwners[nftId] == msg.sender, "nft not owner");
        //  require(nftItemOwner == msg.sender, "nft not owner");
         NFT storage nft = nfts[nftId][useridd];
         id = nft.nftId;
         userid = _userId;
         name = nft.name;
         description = nft.description;
         price = nft.price;
         image = nft.image;
         seller = nft.seller;
         newowner =  nft.newowner;
         isSold = nft.isSold;
       }
       
    function getAllNftItem(uint256 nftId) external view returns (uint256 id, uint256 userid,string memory name, string memory description, uint256 price, string memory image, address seller, address newowner, bool isSold) 
       {
         require(_exists(nftId), "token not minted");
         NFT storage nft = allnfts[nftId];
         id = nft.nftId;
         userid = _userId;
         name = nft.name;
         description = nft.description;
         price = nft.price;
         image = nft.image;
         seller = nft.seller;
         newowner =  nft.newowner;
         isSold = nft.isSold;
       }
     
      function SaleNft(uint256 nftId) public payable SaleNftItem(nftId)
       {
           require(users[nftItemOwner].addr == msg.sender, "You are not buy nft.");
        // require(msg.value == price, "Please submit the asking price in order to complete the purchase");
            uint price = nfts[nftId][_userId].price;
            nfts[nftId][_userId].seller.transfer(msg.value);
            users[nftownaddr].ubalance -= price;
            nfts[nftId][_userId].newowner = payable(msg.sender);
            nfts[nftId][_userId].isSold = true;
            emit NftSold(nftId, _userId, msg.sender, price , true);
       }
       
    function SaleNftwithId(uint256 nftId, uint256 userId) public payable SaleNftItem(nftId)
       {
           require(users[nftItemOwner].addr == msg.sender, "You are not buy nft.");
        // require(msg.value == price, "Please submit the asking price in order to complete the purchase");
            uint price = nfts[nftId][userId].price;
            nfts[nftId][userId].seller.transfer(msg.value);
            users[nftownaddr].ubalance -= price;
            nfts[nftId][userId].newowner = payable(msg.sender);
            nfts[nftId][userId].isSold = true;
            emit NftSold(nftId, userId, msg.sender, price , true);
       }
    
      function ownerOfNft(uint256 nftId) public  view returns (address owner) 
       {
        require(_exists(nftId));
        return NftOwners[nftId];
       }
       
          
      function register(address _address, string memory _username, string memory _password,  string memory _bio) public returns(uint) 
        {
        // require(users[_address].addr == msg.sender);
        // users[userId] = User(userId, msg.sender,  _username, _password _bio, false);
        _userId++;  
         users[_address].id = _userId;
         users[_address].addr = _address;
         users[_address].username = _username;
         users[_address].password = _password;
         users[_address].bio = _bio;
         users[_address].ubalance = getBalance(_address);
         users[_address].isUserLoggedIn = false;
         emit UserRegister(_userId, _address, _username, _password, _bio, users[_address].ubalance);
         transferOwnership(_address);
         nftownaddr = _address;
         return _userId;
         }

           
        function login(address _address, string memory _password) public returns (bool)
        {
             require(keccak256(abi.encodePacked(users[_address].password)) == keccak256(abi.encodePacked(_password)) , "not password equal");
              if (keccak256(abi.encodePacked(users[_address].password)) == keccak256(abi.encodePacked(_password)) ) {
                  users[_address].isUserLoggedIn = true;
                return (users[_address].isUserLoggedIn);
                    
            } else {
                return false;
            }
        }
        
            
        function getUser(address _addr) external view returns (uint256 id, address addr, string memory username, string memory password, string memory bio, uint ubalance, bool isUserLoggedIn) 
        {
            User storage user = users[_addr];
            id = user.id;
            addr = user.addr;
            username = user.username;
            password = user.password;
            bio = user.bio;
            ubalance = user.ubalance;
            isUserLoggedIn = user.isUserLoggedIn;
        }
        
        function checkIsUserLogged(address _address) public view returns (bool) 
        {
            return (users[_address].isUserLoggedIn);
        }

        function logout(address _address) public 
        {
            users[_address].isUserLoggedIn = false;
        }
            
    
}
