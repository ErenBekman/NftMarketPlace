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
          <v-col cols="12" md="6" lg="4">
            <v-card class="portfolio-card d-flex justify-space-around align-content-space-between flex-wrap overflow-hidden"  v-for="(n,index) in nft" :key="index">
              <div class="portfolio-img">
                <img
                  :src="`${n.image}`"
                  class="img-fluid"
                  alt="portfolio"
                />
              </div>
              <v-card-text>
                <h5 class="font-weight-medium font-18">
                  Branding for Theme Designer
                </h5>
                <p class="font-14 mb-0">Digital Marketing</p>
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
    return {};
  },
  methods: {},
};
</script>
