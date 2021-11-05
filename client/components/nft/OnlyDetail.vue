<template>
  <div>
    <v-container class="fill-height set">
      <v-row>
        <v-cols cols="5" md="5" lg="5">
          <v-img
            height="600px"
            width="450px"
            :src="`${nft.image}`"
            v-if="nft.image"
          ></v-img>
          <img  height="600px" width="450px" class="img-fluid" v-else src="~/assets/images/default.png" />

          <v-card
              class="mx-auto"
              max-width="450"
            >
              <v-card-text>
                <div class="text--primary mb-7">
                  <font-awesome-icon :icon="['fas', 'align-left']" class="font"/>
                  <span class="ml-2">Description</span> 
                </div>
                   <p>{{ nft.description }}</p>
              </v-card-text>
            </v-card>
            
        </v-cols>
        <v-cols cols="7" md="7" lg="7" class="ml-9 pl-9">
          <v-card
              class="mx-auto"
              max-width="450"
            >
              <v-card-text>
                <div class="mb-4">{{ nft.name}} #{{ nft.id }}</div>
                <div class="text--primary mb-7">
                    <font-awesome-icon :icon="['fab', 'ethereum']" class="font"/>
                  <span class="font">{{ nft.price }}</span> <span class="fontx">(${{ nft.price * 4.480 }})</span>
                </div>
                    <v-btn
                      depressed
                      color="primary"
                      @click.prevent="buyNftItem()"
                      v-if="!sale"
                    >
                      Buy now
                    </v-btn>
                        <v-btn v-else depressed disabled> Buy now </v-btn>
              </v-card-text>
            </v-card>


          <v-expansion-panels>
            <v-expansion-panel>
              <v-expansion-panel-header>
                Price History
                <font-awesome-icon :icon="['fas', 'chart-line']"/>
              </v-expansion-panel-header>
              <v-expansion-panel-content>
                Lorem ipsum dolor
              </v-expansion-panel-content>
            </v-expansion-panel>

            <v-expansion-panel>
              <v-expansion-panel-header>
                Listings
              <font-awesome-icon :icon="['fas', 'tag']"/>
              </v-expansion-panel-header>
              <v-expansion-panel-content>
                Lorem ipsum dolor
              </v-expansion-panel-content>
            </v-expansion-panel>

            <v-expansion-panel>
              <v-expansion-panel-header>
                Offers
               <font-awesome-icon :icon="['fas', 'sliders-h']"/>
              </v-expansion-panel-header>
              <v-expansion-panel-content>
                Lorem ipsum dolor
              </v-expansion-panel-content>
            </v-expansion-panel>

          </v-expansion-panels>
        </v-cols>
      </v-row>
    </v-container>
  </div>
</template>


<script>
// import getWeb3 from '../../getWeb3'
// import Nft from '../../../build/contracts/ENFT.json'
  export default {
    // props:['nft'],
    data: () => ({
        nft:[],
        loaded:false,
        web3: null, 
        account: null, 
        NftInstance: null,
        nftId:null,
        total:null,
        okey:false,
        img:'default',
        latest: null,
        price:null,
        sale:false,
        num:null,
    }),
    //   async asyncData({params}) {
    //     let num = params.id
    //     return { num }
    // },
  async mounted() {
      try {
                // let web3 = await getWeb3();
                let num = this.$route.params.id;
                this.num = num
                let web3 = await this.$web3;
                const [accounts] = await web3.eth.getAccounts();
                let networkId = await web3.eth.net.getId();     
                let NftInstance = new web3.eth.Contract(
                  this.$Nft.abi,
                  this.$Nft.networks[networkId] && this.$Nft.networks[networkId].address,
                );

                this.web3 = web3;
                this.NftInstance = NftInstance;
                this.total = await NftInstance.methods.totalSupply().call()
                this.account = accounts;
                // const id = await NftInstance.methods.getNftId().call()
                const latest = await web3.eth.getBlockNumber();
                let logs = await this.NftInstance.getPastEvents('NFTCreated', {
                   fromBlock: latest - 100,
                   toBlock: latest
                  });
                    let len = logs.length - 1;
                    const id = logs[len].returnValues.nftId;
                    this.sale = logs[len].returnValues.isSold;
                    this.nftId = id;
                    let data = await NftInstance.methods.getNftItem(num).call()
                    this.nft = data
                    this.latest = latest
                    this.price = logs[len].returnValues.price;

                    this.loaded = true;
                    if (this.loaded) {
                      const Toast = this.$swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: (toast) => {
                          toast.addEventListener('mouseenter', this.$swal.stopTimer)
                          toast.addEventListener('mouseleave', this.$swal.resumeTimer)
                        }
                      })

                      Toast.fire({
                        icon: 'success',
                        title: 'Loaded in successfully'
                      })
                  }
                if(this.okey){
                const Toast = this.$swal.mixin({
                  toast: true,
                  position: 'top-end',
                  showConfirmButton: false,
                  timer: 3000,
                  timerProgressBar: true,
                  didOpen: (toast) => {
                    toast.addEventListener('mouseenter', this.$swal.stopTimer)
                    toast.addEventListener('mouseleave', this.$swal.resumeTimer)
                  }
                })

                Toast.fire({
                  icon: 'success',
                  title: 'You Bought New NFT'
                })
               }
          }catch(e) {
            this.loaded = false;
             if(!this.loaded){
            this.$swal.fire({
              title: 'Fail!',
              text: 'Failed to load web3, accounts, or contract. Check console for details.',
              icon: 'error',
              confirmButtonText: 'Ok!'
            })
            }
          }
  },
    methods: {
      async buyNftItem(){
         await this.NftInstance.methods.SaleNft(this.nftId)
              .send({from: this.account, value:this.price})
        this.okey = true
        this.sale = true
      },
    },
  }
</script>
<style scoped>

.font {
  font-weight: 200;
  font-size: 30px;
}
.fontx {
  font-weight: 200;
  font-size: 15px;
}
.set{
  margin-top: 120px;

}

</style>