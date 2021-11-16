<template>
<div>
  <v-row justify="center" align="center">
    <v-col cols="12" >
      <Banner/>
    </v-col>
    <v-col cols="12" >
      <v-flex xs12 class="text-xs-center" mt-5>
        <h1 class="text-center mt-16 mb-16">Notable Drops</h1>
      </v-flex>
      <!-- <Card/> -->
      <!-- <Slide :nft="nft" /> -->
    </v-col>

    <v-col cols="12">
      <Feature />
    </v-col>

  </v-row>
</div>
</template>

<script>
export default {
  components: {
      Banner: () => import("@/components/custom/banner/Banner1.vue"),
      Feature: () => import("@/components/custom/features/Feature1.vue"),
      Slide: () => import("@/components/custom/slide/SlideGroup.vue")
  },
  data: () => ({
      loaded:false,
      web3: null, 
      account: null, 
      NftInstance: null,
  }),
    // async asyncData({$axios}) {
    //    return await $axios.$get("https://api.coinranking.com/v2/nfts?limit=10")
    //     .then(response => {
    //        let nft = response.data.nfts
    //        return { nft }
    //     })
    // },

     async mounted() {
      try {
                let web3 = await this.$web3;
                const [accounts] = await web3.eth.getAccounts();
                let networkId = await web3.eth.net.getId();   
                let NftInstance = new web3.eth.Contract(
                  this.$Nft.abi,
                  this.$Nft.networks[networkId] && this.$Nft.networks[networkId].address,
                );
                this.web3 = web3;
                this.NftInstance = NftInstance;
                this.account = accounts;
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
                this.$nuxt.refresh();
                this.$nuxt.refresh();
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

}
</script>

<style>

</style>