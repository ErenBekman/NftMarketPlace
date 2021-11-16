<template>
  <div>
      <div class="portfolio-component mini-spacer" v-if="nft.length <= 0">
            <v-row justify="center" >
          <v-col cols="12" sm="10" md="9" lg="7">
            <div class="text-center">
              <h2 class="section-title font-weight-medium">
                You don't created nft yet.
              </h2>
              <p>
                You can relay on our amazing features list and also our customer
                services will be great experience for you without doubt and in
                no-time
              </p>
            </div>
          </v-col>
        </v-row>
      </div>

    <div class="portfolio-component mini-spacer" v-if="nft.length > 0">
      <v-container>
        <v-row justify="center" >
          <v-col cols="12" sm="10" md="9" lg="7">
            <div class="text-center">
              <h2 class="section-title font-weight-medium">
                Our Recent work with three column
              </h2>
              <p>
                You can relay on our amazing features list and also our customer
                services will be great experience for you without doubt and in
                no-time
              </p>
            </div>
          </v-col>
        </v-row>

        <v-row class="mt-13">
          <v-col cols="12" class="d-flex justify-space-around align-center ml-15">
            <v-card class="portfolio-card mr-15"   v-for="(n,index) in nft" :key="index">
              <div class="portfolio-img">
                 <nuxt-link :to="`/nft/${n.id}`">
                    <img
                    :src="`${n.image}`"
                    class="img-fluid"
                    alt="portfolio"
                    v-if="n.image"
                    />
                   <img class="img-fluid" v-else src="~/assets/images/default.png" />
                </nuxt-link>
              </div>
              <v-card-text>
                <h5 class="font-weight-medium font-18">
                  {{ n.name }}
                </h5>
                <p class="font-14 mb-0">
                  <font-awesome-icon :icon="['fab', 'ethereum']" class="font"/>
                   {{ n.price }}
                   </p>
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </div>
  </div>
</template>

<script>
export default {
  name: "Portfolio",
  data() {
    return {
        nft:[],
        loaded:false,
        web3: null, 
        account: null, 
        NftInstance: null,
        nftId:null,
        okey:false,
        isSale:false,
    };
  },
   async mounted() {
      try {
                let web3 = await this.$web3;
                const [accounts] = await web3.eth.getAccounts();
                let networkId = await web3.eth.net.getId();    
                let NftInstance = new web3.eth.Contract(
                  this.$Nft.abi,
                  this.$Nft.networks[networkId] && this.$Nft.networks[networkId].address,
                );
                

                const latest = await web3.eth.getBlockNumber();
                this.web3 = web3;
                this.NftInstance = NftInstance;
                this.account = accounts;



                let logs = await NftInstance.getPastEvents('NFTCreated', {
                  fromBlock: latest - 100,
                  toBlock: latest
                });
              let len = logs.length - 1;
              this.nftId = logs[len].returnValues.nftId;
              const userid = logs[len].returnValues.userId;
              console.log(userid);





                let lobs = await NftInstance.getPastEvents('NftSold', {
                  fromBlock: latest - 100,
                  toBlock: latest
                });
                let lan = lobs.length - 1;
                console.log(lobs[lan].returnValues);

                for (let i = 0; i < lobs.length; i++) {
                    let data = await NftInstance.methods.getAllNftItem(i).call()
                    this.nft.push(data);
                    console.log(data)
                    this.okey = true
                }

                this.isSale = lobs[lan].returnValues.isSold;
                
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
                console.log(NftInstance);
                console.log(web3);
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
};
</script>



<style scoped>
.flex{
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding:20px;
  margin: 20px;
}
.pxx{
  margin-bottom: 75px;
}
.list {
     display: flex;
     justify-content: center;
     align-items: center;
     overflow: hidden;
     padding:15px;
     margin: 25px;
}
.listItem {
     display: flex;
     flex-wrap: wrap;
     justify-content: center;
}
</style>