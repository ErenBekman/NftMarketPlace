<template>
      <v-container>
        <v-flex xs12 class="text-xs-center y">
            <h1 class="text-center mt-14">Register</h1>
        </v-flex>
        <v-row>
            <v-col cols="6" class="pa-md-4 mx-auto y">
             <v-form ref="registerForm" v-model="valid" lazy-validation >
                <v-row>
                    <v-col cols="12">
                          <v-textarea
                            v-model="useraddress" 
                            label="Address"
                            auto-grow
                            outlined
                            rows="1"
                        ></v-textarea>
                    </v-col>

                    <v-col cols="12">
                        <v-text-field 
                        v-model="username" 
                        label="Name" 
                        maxlength="20" 
                        required>
                      </v-text-field>
                    </v-col>
                    <!-- <v-col cols="12">
                        <v-text-field
                         v-model="form.email" 
                         :rules="emailRules" 
                         label="E-mail" 
                         required>
                         </v-text-field>
                    </v-col> -->
                    <v-col cols="12">
                        <v-text-field
                         v-model="userpassword" 
                         :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'" 
                         :type="show1 ? 'text' : 'password'" 
                         name="input-10-1" 
                         label="Password" 
                         hint="At least 6 characters" 
                         counter @click:append="show1 = !show1">
                         </v-text-field>
                    </v-col>
                    <!-- <v-col cols="12">
                        <v-text-field
                         block 
                         v-model="form.password_confirmation"
                          :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'" 
                          :rules="[rules.required, passwordMatch]" 
                          :type="show1 ? 'text' : 'password'" 
                          name="input-10-1" 
                          label="Confirm Password" 
                          counter 
                          @click:append="show1 = !show1">
                          </v-text-field>
                    </v-col> -->

                    <v-col cols="12">
                        <v-textarea
                          v-model="userbio"
                          label="bio"
                          auto-grow
                          outlined
                          rows="3"
                          row-height="25"
                          shaped
                        ></v-textarea>
                   </v-col>

                    <v-spacer></v-spacer>
                    
                        <v-btn 
                        x-large block 
                        :disabled="!valid"
                         @click.prevent="register()" 
                         class="btn"
                         >
                         Register
                         </v-btn>
                   
                        <span class="text-red-200 italic" v-if="errors">{{ errors[0] }}</span>
                </v-row>
             </v-form>
            </v-col>
        </v-row>
      </v-container>
</template>

<script>
export default {
    
  // middleware: ['guest'],
  computed: {
    passwordMatch() {
      return () => this.password === this.verify || "Password must match";
    }
  },
  data: () => ({
    valid: true, 
    form: {
        name: "",
        email: "",
        password: "",
        password_confirmation: "",
    },

    // emailRules: [
    //   v => !!v || "Required",
    //   v => /.+@.+\..+/.test(v) || "E-mail must be valid"
    // ],

    show1: false,
    // rules: {
    //   required: value => !!value || "Required.",
    //   min: v => (v && v.length >= 6) || "Min 6 characters"
    // },
    errors: [],
    loaded:false,
      web3: null, 
      account: null, 
      okey: false,
      latest:null,
      useraddress: "",
      username: "",
      userpassword: "",
      userbio: "",
  }),
    methods: {
    async register() {
      // try {
        // await this.$axios.$get('http://nft-backend.test/sanctum/csrf-cookie')
        // await this.$axios.$post('http://nft-backend.test/api/register', this.form)
          // .then((response) => {
              // console.log(response)
              // this.$auth.setUser(response.user)
              // localStorage.setItem("token", response.token)
              // this.$auth.setUserToken(response.token) **
              // this.$router.push('/auth/login')
               await this.NftInstance.methods.register(this.useraddress,this.username,this.userpassword,this.userbio)
              .send({from: this.useraddress})
              
                // await this.NftInstance.methods.transferOwnership(this.useraddress).call()
              
               this.okey = true
              if (this.okey) {
                this.$swal.fire({
                  position: 'top-end',
                  icon: 'success',
                  title: 'You Register Succesfull',
                  showConfirmButton: false,
                  timer: 1500
                })
              }
              this.$router.push('/auth/login')
          // })
          // .catch((err) => {
          //     this.errors = err.response.data.errors
          // })

      // } catch (error) {}

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

<style>
.y{
  margin-top: 90px;
}
.x{
  margin-top: 20px;
}
.btn {
  margin-bottom: 40px;
}
</style>







