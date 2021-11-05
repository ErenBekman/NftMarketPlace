<template>
  <div>
    <!-- -----------------------------------------------
          Start Header
    ----------------------------------------------- -->
    <v-app-bar
      app
      class="position-sticky navbar-light header1 y"
      flat
    >
      <v-container class="py-0 fill-height">
        <!-- Logo -->
        <div class="logo">
          <NLink to="/">
            <v-img
              :src="require('@/assets/images/logos/purple-logo.png')"
              alt="logo"
            />
          </NLink>
        </div>

         <nuxt-link class="nav-link x" nuxt to="/"> 
            <p class="text">OpenSea</p>
         </nuxt-link>


        <v-spacer></v-spacer>
        <v-btn class="d-block d-md-none" text @click="toggleClass()">
          <v-app-bar-nav-icon />
        </v-btn>
        <!-- Desktop view Navigation -->
        <div
          class="navigation"
          v-bind:class="[isActive ? 'd-block' : '']"
          @click="isActive = !isActive"
        >

          <ul class="navbar-nav">

            <li class="nav-item" text>
              <nuxt-link class="nav-link x" nuxt to="/nft/all"> Marketplace </nuxt-link>
            </li>

            <li class="nav-item" text>
              <nuxt-link class="nav-link x" nuxt to="/nft/create"> Create </nuxt-link>
            </li>

          </ul>
        </div>
        <!-- login-regiter -->
        
               <v-btn
                    clnuxt-linkss="d-none d-lg-flex btn-custom-nm ml-5"
                    nuxt
                    outlined
                    color="primary"
                    to="/"
                    elevation="0"
              >
              <div class="dropdown">
              <nuxt-link class="nav-link x" nuxt to="/"> 
              <button class="nav-link x" v-if="$auth.loggedIn">{{ $auth.user.name }}</button>
              </nuxt-link>
              <!-- <nuxt-link class="nav-link x" nuxt to="/auth/login" v-else> Login </nuxt-link> -->
              
             <li class="nav-item x" text v-if="!$auth.loggedIn">
              <nuxt-link class="nav-link x" nuxt to="/auth/login"> Login </nuxt-link>
             </li>

              <div class="dropdown-content">
                <div class="d-flex">
                    <font-awesome-icon :icon="['fas', 'user']" class="font"/>
                    <nuxt-link class="nav-link x" nuxt to="/accounts"> Profile </nuxt-link>
                </div>

                <div class="d-flex">
                    <font-awesome-icon :icon="['fas', 'th']" class="font"/>
                    <nuxt-link class="nav-link x" nuxt to="/nft/collections"> Collection </nuxt-link>
                </div>

                <div class="d-flex x">
                  <font-awesome-icon :icon="['fas', 'sign-out-alt']" class="font" v-if="$auth.loggedIn"/>
                  <li class="nav-item still x" text v-if="$auth.loggedIn" @click.prevent="logout()">
                  <nuxt-link class="nav-link x" nuxt to="/auth/login"> Log Out </nuxt-link>
                  </li>
                </div>
              </div>
          </div>
        </v-btn>
          <li class="nav-item z" text>
             
              <div class="text-center">
            <v-menu
              v-model="menu"
              :close-on-content-click="false"
              :nudge-width="200"
              offset-x
            >
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  color="indigo"
                  dark
                  v-bind="attrs"
                  v-on="on"
                >
                  <font-awesome-icon :icon="['fas', 'wallet']" class="font"/>
                </v-btn>
              </template>

              <v-card
                class="mx-auto"
                max-width="290"
              >
                <v-list>
                  <v-list-item>
                    <v-list-item-avatar>
                      <img
                        src="https://cdn.vuetifyjs.com/images/john.jpg"
                        alt="John"
                      >
                    </v-list-item-avatar>

                    <v-list-item-content>
                      <v-list-item-title>{{ $auth.user.name }}</v-list-item-title>
                      <v-list-item-subtitle>{{ account }}</v-list-item-subtitle>
                    </v-list-item-content>
                  </v-list-item>
                </v-list>

                <v-divider></v-divider>

                    <v-card
                      class="mx-auto"
                      max-width="300"
                    >
                      <v-card-text class="c">
                        <p class="text-h4 text--primary">
                          Total balance
                        </p>
                        <p class="d">${{ total }} USD</p>
                      </v-card-text>
                      <v-card-actions>
                        <v-btn
                        depressed
                        block
                        color="primary"
                      >
                        Add Funds
                      </v-btn>
                      </v-card-actions>
                    </v-card>
              </v-card>
          </v-menu>
        </div>
      </li>
     </v-container>
    </v-app-bar>
  </div>
</template>

<script>
export default {
  name: "Header1",
  data() {
    return {
      isActive: false,
        admins: [
        ['Management', 'mdi-account-multiple-outline'],
        ['Settings', 'mdi-cog-outline'],
      ],
      cruds: [
        ['Create', 'mdi-plus-outline'],
        ['Read', 'mdi-file-outline'],
        ['Update', 'mdi-update'],
        ['Delete', 'mdi-delete'],
      ],
      fav: true,
      menu: false,
      message: false,
      hints: true,
      loaded:false,
      web3: null, 
      account: null, 
      NftInstance: null,
      total:null,
    };
  },
  methods: {
    toggleClass: function (event) {
      this.isActive = !this.isActive;
    },
    async logout(){
         await  this.$auth.logout()
    }
  },

    async mounted() {
      try {
                // let web3 = await getWeb3();
                let web3 = await this.$web3;
                const [accounts] = await web3.eth.getAccounts();
                let networkId = await web3.eth.net.getId();     
                let NftInstance = new web3.eth.Contract(
                  this.$Nft.abi,
                  this.$Nft.networks[networkId] && this.$Nft.networks[networkId].address,
                );

                this.web3 = web3;
                this.NftInstance = NftInstance;
                // this.total = await NftInstance.methods.totalSupply().call()
                this.total = await NftInstance.methods.balanceOf(accounts).call()
                this.account = accounts
                this.loaded = true;  
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
  .stil {
    text-decoration: none;
    text-transform: capitalize;
    letter-spacing: 2px;
    word-spacing: 5px;
    font-weight: bold;
  }
  .z{
    list-style-type: none;
     text-decoration: none;
     margin-left:5px;
    
  }
  .d{
    font-size: 24px;
    font-weight: 400;
  }
  .c{
    text-align: center;
  }
  .abs {
    position:absolute;
    left:-0px;
  }
  .x {
     list-style-type: none;
     text-decoration: none;
    text-transform: capitalize;
    color: rgba(172, 106, 172, 1);
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  }
  .y {
    height: 75px !important;
  }
  .text{
    font-size: 30px;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
    color: #04111E;
    margin-top: 4px;
  }
  .font {
    font-size: 20px;
    margin-left: 5px;
    margin-top: 12px;
  }
  .still {
    list-style-type: none;
  }
  .dropdown {
  position: relative;
  display: inline-block;
}
.dropbtn {
  background-color: #4CAF50;
  color: white;
  padding: 16px;
  font-size: 16px;
  border: none;
  cursor: pointer;
}
.dropdown-content {
  display: none;
  position: absolute;
  background-color: #f9f9f9;
  width: 153px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 1;
}

.dropdown-content a {
  color: black;
  padding: 12px 16px;
  text-decoration: none;
  display: block;
}

.dropdown-content a:hover {background-color: #f1f1f1}

.dropdown:hover .dropdown-content {
  display: block;
}

.dropdown:hover .dropbtn {
  background-color: #3e8e41;
}
</style>