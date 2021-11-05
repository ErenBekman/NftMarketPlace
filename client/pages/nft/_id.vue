<template>
  <div>
    <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Eius amet ullam esse, eligendi accusamus eaque illum aperiam explicabo doloremque aliquid, quis tenetur consequuntur labore quaerat. Nostrum quod praesentium suscipit sint.</p>
      <NftOnlyDetail />
  </div>
</template>

<script>
export default {
    components: {
    NftOnlyDetail : () => import("@/components/nft/OnlyDetail.vue")
  },
  // data: () => ({
  //     id:null,
  //   }),
    // async asyncData({params}) {
    //   let num = params.id
    //   return { num }
    // },
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
