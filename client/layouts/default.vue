<template>
  <v-app dark>
    <!--v-if="$route.name!=='login'"-->
    <Header />
    <v-main>
      <nuxt />
    </v-main>
    <Footer class="a"/>
  </v-app>
</template>

<script>
export default {
  head() {
    return {
      title: "NFT MarketPlace",
      meta: [
        {
          hid: "description",
          name: "NFT MarketPlace",
          content: "NFT MarketPlace"
        }
      ]
    };
  },
  components: {
    Header: () => import("@/components/custom/header/Header1.vue"),
    // Footer: () => import("@/components/custom/contact/Contact.vue")
    Footer: () => import("@/components/custom/footer/Footer.vue")
  },
  methods: {}
};
</script>

<style>
.a{
  margin-top: 90px;
}
</style>
