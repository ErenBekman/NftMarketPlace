<template>
<div>
        <v-card class="mx-auto set" max-width="1000" tile>
            <v-img height="200" src="https://cdn.vuetifyjs.com/images/cards/server-room.jpg"></v-img>
            <v-row style="margin:2.5%;position:absolute; top: 130px">

                        <v-list-item>
                        <v-list-item-avatar size="100">
                            <img
                              src="https://www.w3schools.com/howto/img_avatar.png"
                              alt="John"
                            >
                          </v-list-item-avatar>
                          <v-list-item-content>
                            <v-list-item-title class="title" style="margin-top:20px;">{{ username }}</v-list-item-title>
                            <v-list-item-subtitle>{{ userbio }}</v-list-item-subtitle>
                          </v-list-item-content>
                        </v-list-item>
          </v-row>
        </v-card>
          <v-divider></v-divider>

              <UiCollection />
    </div>
</template>

<script>
    export default {
        pageTitle: 'My Profile',
        components: {
            UiCollection : () => import("@/components/basic/UiSaleCollection.vue")
        },
        data () {
            return {
                loading: false,
                form: {
                    firstName: 'John',
                    lastName: 'Doe',
                    contactEmail: 'john@doe.com',
                    avatar: 'MALE_CAUCASIAN_BLOND_BEARD'
                },
                showAvatarPicker: false,
                loaded:false,
                web3: null, 
                account: null, 
                okey: false,
                latest:null,
                useraddress: "",
                username: "",
                userpassword: "",
                userbio: "",
            }
        },
        methods: {
            openAvatarPicker () {
                this.showAvatarPicker = true
            },
            selectAvatar (avatar) {
                this.form.avatar = avatar
            }
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
                this.latest = latest
                const user = await NftInstance.methods.getUser(accounts).call()
                this.username = user.username;
                this.userbio = user.bio;
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
    }
</script>

<style scoped>
.set{
  margin-top: 120px;
}
</style>