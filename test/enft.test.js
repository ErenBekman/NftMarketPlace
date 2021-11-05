// const truffleContract = require('truffle-contract');
// const nftContract = require('../build/contracts/ENFT.json');
// const web3provider = 'http://127.0.0.1:7545';
// const storage = truffleContract(nftContract);
// storage.setProvider(web3provider);
const ENFT = artifacts.require('./ENFT.sol');
const truffleAssert = require('truffle-assertions');
// const ENFT = artifacts.require("ENFT");
// require("dotenv").config({path: "../.env"}); //use : process.env.ADI
contract('ENFT', (accounts) => {

    let enftInstance;

    before(async () => {
        enftInstance = await ENFT.deployed();
        // enftInstance = await storage.deployed();
    });

    describe('mintNFT', async () => {
        it('1', async () => {
            const tokenUR = "token";
            const _name = "nftName";
            const description = "nftDescription";
            const price = 20;
            const image = "nftImage.jpg";

            const mintedNftId = await enftInstance.mintNft(tokenUR,_name,description,price,image);

            truffleAssert.eventEmitted(mintedNftId, "NFTCreated", event => {
                const { name }  = event;
                return (name === _name);
              });

        });

        it('2', async () => {
            const nft = await enftInstance.nfts(0);
            assert.equal(parseInt(nft.price.toString()), 20);
            assert.equal(parseInt(nft.nftId.toString()), 0);
            assert.equal(nft.isSold, false);
          });

        it('3', async () => {
            const tokenUR = "token";
            const _name = "nftName";
            const description = "nftDescription";
            const price = 20;
            const image = "nftImage.jpg";

            const tx = await enftInstance.mintNft(tokenUR,_name,description,price,image);
          
            truffleAssert.eventEmitted(tx, 'NFTCreated', async event => {
              const { name }  = event;
              return (name === _name);
            });

          });

          it('4', async () => {
            const nftId = await enftInstance.totalSupply();
            assert.equal(parseInt(nftId.toString()), 2);
          });
          
    });

    describe('getNFT', async () => {
        it('5', async () => {
          const nfts = await enftInstance.getNftItem(0);
          assert.equal(nfts.name, "nftName");
          assert.equal(nfts.description, "nftDescription");
          assert.equal(nfts.image, "nftImage.jpg");
          assert.equal(nfts.price.toString(), 20);
        });
    });

      describe('buyNFT', () => {
        it('6', async () => {
        //   const balance = await web3.eth.getBalance(accounts[1]);
          const balance = accounts[1];
          const tx = await enftInstance.SaleNft(0, { from: balance, value: 50 });
          truffleAssert.eventEmitted(tx, 'NftSold', async (event) => {
            const { buyer }  = event;
            return (buyer === balance);
          });
        });
    });
});