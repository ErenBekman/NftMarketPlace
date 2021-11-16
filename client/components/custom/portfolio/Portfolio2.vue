<template>
  <div>
    <div class="portfolio-component mini-spacer">
      <v-container>
        <v-row justify="center">
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
                    :src="`${n.image_url}`"
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
                  <!-- {{ n.price }} -->
                  {{ n.description }}
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
  props:['nft'],
  data() {
    return {
      loaded:false,
    };
  },
  methods: {},
  async mounted() {
      try {
                let web3 = await this.$web3;
                const [accounts] = await web3.eth.getAccounts();
                let networkId = await web3.eth.net.getId();    
                let NftInstance = new web3.eth.Contract(
                  this.$Nft.abi,
                  this.$Nft.networks[networkId] && this.$Nft.networks[networkId].address,
                );
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
.cards {
   display: flex;
   flex-wrap: wrap;
   justify-content: space-between;
}

.card {
	flex: 0 1 24%;
}
</style>