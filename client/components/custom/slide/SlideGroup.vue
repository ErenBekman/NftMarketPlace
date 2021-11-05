<template>
<div>
  <v-sheet
    class="mx-auto"
    elevation="8"
    max-width="80%"
  >
    <v-slide-group
      v-model="model"
      class="pa-4"
      active-class="success"
      show-arrows
    >
      <v-slide-item
        v-for="(n,index) in nft"
        :key="index"
      >

      <v-card width="200" class="ma-4">
          <v-card-title>
              <v-img max-height="300" max-width="150" :src="`${n.image}`"></v-img>
           </v-card-title>
          <v-card-text>
              <b>{{ n.price }}$</b>
          </v-card-text>
       </v-card>

      </v-slide-item>
    </v-slide-group>
  </v-sheet>
</div>
</template>


<script>
  export default {
   props:['nft'],
    data: () => ({
      model: null,
    }),
  }
</script>