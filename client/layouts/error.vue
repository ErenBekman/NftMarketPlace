<template>
  <v-app dark>
      <Error />
  </v-app>
</template>

<script>
export default {
  components: {
      Error: () => import("@/components/shared/lp-banner/Banner404.vue")
  },
}
</script>

<style scoped>
h1 {
  font-size: 20px;
}
</style>
