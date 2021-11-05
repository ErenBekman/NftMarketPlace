<template>
  <div>
    <div class="mini-spacer">
      <v-container>
        <!-- -----------------------------------------------
            Start Ui Form
        ----------------------------------------------- -->
        <v-row justify="center">
          <v-col cols="12" sm="10" md="9" lg="7">
            <div class="text-center">
              <h2 class="ui-title font-weight-bold">Create new item</h2>
              <h3>Image, Video, Audio, or 3D Model</h3>
              <p>File types supported: JPG, PNG, GIF, SVG, MP4, WEBM, MP3, WAV, OGG, GLB, GLTF. Max size: 40 MB</p>
               <p> URL :</p>
               <v-progress-circular
                  indeterminate
                  color="primary"
                  v-show="progress"
                ></v-progress-circular>
              <a className="text-info font-weight-bold" :href="this.fileIPFSLink" target="_blank">
                  {{ fileIPFSLink }}
              </a>
            </div>
          </v-col>
        </v-row>

        <!-- -----------------------------------------------
            End Ui Form
        ----------------------------------------------- -->
      </v-container>
    </div>
    <div>
      <v-container>
        <v-row justify="center">
          <v-col cols="12" sm="10" md="9" lg="7">
            <v-form
                ref="form"
                lazy-validation
              >
            <v-card>
                <v-file-input
                  v-model="form.image"
                  label="File image"
                  name="image"
                  filled
                  prepend-icon="mdi-camera"
                  show-size             
                >
               <v-chip
                  small
                  label
                  color="primary"
                >
                  <!-- {{ text }} -->
                </v-chip>
              </v-file-input>


              <v-card-text>
                <v-text-field
                  label="Name"
                  v-model="form.name"
                  placeholder="Enter name"
                ></v-text-field> <br>
            
                  <v-textarea
                        v-model="form.description"
                          label="Desc.."
                          auto-grow
                          outlined
                          name="description"
                          rows="3"
                          row-height="25"
                          shaped
                 ></v-textarea>

                  <v-text-field
                      v-model="form.price"
                      label="Price"
                      name="price"
                      required
                    ></v-text-field>

                <div class="mt-10">
                  <v-btn color="success" elevation="0" class="mr-2" block @click.prevent="create()">Save</v-btn>
                </div>
              </v-card-text>
            </v-card>
            </v-form>
          </v-col>
        </v-row>
      </v-container>
    </div>
  </div>
</template>
<script>
import jsonlint from "jsonlint-mod"
if (process.browser){
window.jsonlint = jsonlint;
}

import { create as ipfsHttpClient } from 'ipfs-http-client'
// const ipfs = ipfsHttpClient({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' })
const ipfs = ipfsHttpClient("https://ipfs.infura.io:5001/api/v0");

  // import getWeb3 from "../../getWeb3";
  // import ENFT from "../../contracts/ENFT.json";
export default {
  name: "UiForm",
  data() {
    return {
     form: {
        name: '',
        description: '',
        price: '',
        image: [],
      },
      show1: false,
      show2: false,
      checkbox2: false,
      rules: {
        required: (value) => !!value || "Required.",
        min: (v) => v.length >= 8 || "Min 8 characters",
        emailMatch: () => "The email and password you entered don't match",
      },
      fileIPFSLink: "",
      fileUploadLoading: false,
      progress: false,
      loaded:false,
      web3: null, 
      account: null, 
      ENFT: null,
    };
  },
   methods: {
      async mounted() {
          try {
                const web3 = await getWeb3();
              
                const networkId = await web3.eth.net.getId();
                // const networkId = await web3.eth.getChainId();    
                const networkData = ENFT.networks[networkId];
                const ENFT = new web3.eth.Contract(ENFT.abi, networkData.address);  
                const account = await web3.eth.getAccounts();
                // const ENFT = new web3.eth.Contract(
                //   ENFT.abi,
                //   ENFT.networks[networkId] && ENFT.networks[networkId].address,
                // );
                this.loaded = true;
          }catch(e) {
            alert("Failed to load web3, accounts, or contract. Check console for details.");
          }

        },
      async create() {
        let formdata = new FormData();
        Object.keys(this.form).forEach(element => {
          formdata.append(element, this.form[element])
        });
        await this.$axios.$post('http://nft-backend.test/api/nft', formdata)
          .then( async () => {
              this.fileUploadLoading = true
              this.progress = true
              const cid  = await ipfs.add(this.form.image)
              this.fileIPFSLink = `https://ipfs.infura.io/ipfs/${cid.path}`
              this.fileUploadLoading = false
              this.progress = false
              const sol = await this.ENFT.methods.mintNft(formdata);
              console.log(sol);
          })
        },
      },
};
</script>

<style scoped>
.v-progress-circular {
  margin: 1rem;
}

</style>