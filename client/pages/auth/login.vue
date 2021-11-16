<template>
    <v-container class="y justify-center">
      <v-flex xs12 class="text-xs-center" mt-5>
        <h1 class="text-center mt-14">Sign In</h1>
      </v-flex>
        <v-row>
            <v-col cols="6" class="pa-md-4 mx-auto">
                    <v-form
                    ref="form"
                    v-model="valid"
                    lazy-validation
                >
                    <!-- <v-text-field
                    v-model="form.email"
                    :rules="emailRules"
                    label="E-mail"
                    required
                    ></v-text-field> -->

                    <v-text-field
                    v-model="useraddress"
                    label="Address"
                    ></v-text-field>

                    <!-- <v-text-field
                    v-model="form.password"
                    :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                    :rules="[rules.required, rules.min]"
                    :type="show1 ? 'text' : 'password'"
                    name="input-10-1"
                    label="Password"
                    hint="At least 6 characters"
                    counter
                   @click:append="show1 = !show1"
                    required
                    ></v-text-field> -->

                    <v-text-field
                    v-model="userpassword"
                    :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                    :type="show1 ? 'text' : 'password'"
                    name="input-10-1"
                    label="Password"
                    hint="At least 6 characters"
                   @click:append="show1 = !show1"
                    ></v-text-field>

                    <!-- <v-checkbox
                    v-model="checkbox"
                    :rules="[v => !!v || 'You must agree to continue!']"
                    label="Do you agree?"
                    required
                    ></v-checkbox> -->

                    <v-btn
                    :disabled="!valid"
                    class="mr-4"
                    block
                    @click="login"
                    >
                    SIGN IN
                    </v-btn>

                    <p style="margin-top:20px;text-align:center;">
                      If you haven't registered yet, please 
                      <nuxt-link to="/auth/register">register.</nuxt-link>
                    </p>
                    

                </v-form>
            </v-col>
        </v-row>
    </v-container>
</template>


<script>
  export default {
    // middleware:  ['guest'],
    data: () => ({
      show1: false,
      valid: true,
      // rules: {
      //     required: value => !!value || 'Required.',
      //     min: v => v.length >= 6 || 'Min 6 characters',
      //     emailMatch: () => (`The email and password you entered don't match`),
      //   },
      // emailRules: [
      //   v => !!v || 'E-mail is required',
      //   v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      // ],
      select: null,
      checkbox : false,
      form :{
        email : '',
        password : '',
        device_name: 'nuxt'
      },
      loaded:false,
      web3: null, 
      account: null, 
      okey: false,
      useraddress: null,
      userpassword: null,
    }),

    methods: {
      async login () {
        // this.$refs.form.validate()
        // await this.$auth.loginWith('local' , {data:this.form})
        //  await this.$axios.$post('http://nft-backend.test/api/login', this.form)
        // .then(response => {
            // localStorage.setItem("token", response.data);
            // this.$router.push('/')
        // })
        let log = await this.NftInstance.methods.login(this.useraddress,this.userpassword)
        .send({from: this.useraddress})
        console.log(log)

        // await this.NftInstance.methods.transferOwnership(this.useraddress)
        // .send({from: this.useraddress})

        this.okey = true
        if (this.okey) {
          this.$swal.fire({
            position: 'top-end',
            icon: 'success',
            title: 'login succesfull!',
            showConfirmButton: false,
            timer: 1500
          })
        }
        this.$router.push('/')
      },

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
.y{
  margin-top: 200px;
}
</style>