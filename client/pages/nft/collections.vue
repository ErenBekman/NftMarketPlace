<template>
  <div>
    <UiCollection />
  </div>
</template>

<script>
export default {
  components: {
    UiCollection : () => import("@/components/basic/UiCollection.vue")
  },
  // async asyncData({$axios}) {
  //   return await $axios.$get('http://nft-backend.test/api/nft')
  //     .then(response => {
  //       let nft = response.data
  //       return { nft }
  //     })
  // },
}
</script>

<style>

</style>