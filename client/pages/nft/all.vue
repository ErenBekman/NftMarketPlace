<template>
  <div>
    <Card />
  </div>
</template>

<script>
export default {
  components: {
    Card: () => import("@/components/custom/portfolio/Portfolio.vue")
  },
  data(){
    return {

    }
  },

}
</script>

<style>

</style>