<template>
  <div>
      <NftOnlyDetail />
  </div>
</template>

<script>
export default {
    components: {
    NftOnlyDetail : () => import("@/components/nft/OnlyDetail.vue")
  },

  //  async asyncData({params, $axios}) {
  //    return await $axios.$get(`http://nft-backend.test/api/nft/${params.id}`)
  //      .then(response => {
  //          let data = response.data
  //           return { data }
  //       }).catch(error => {
  //         console.log('Request cancelled' , error)
  //  })
  // }

}
</script>

<style scoped>
</style>
