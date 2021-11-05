<template>
  <v-card class="mx-auto set" max-width="1000" tile>
      <v-img height="200" src="https://cdn.vuetifyjs.com/images/cards/server-room.jpg"></v-img>
      <v-row style="margin:2.5%;position:absolute; top: 130px">

                  <v-list-item>
                   <v-list-item-avatar size="100">
                      <img
                        src="https://www.w3schools.com/howto/img_avatar.png"
                        alt="John"
                      >
                    </v-list-item-avatar>
                    <v-list-item-content>
                      <v-list-item-title class="title" style="margin-top:20px;">{{ $auth.user.name }}</v-list-item-title>
                      <v-list-item-subtitle>Software Engineer | dokanee</v-list-item-subtitle>
                    </v-list-item-content>
                  </v-list-item>
    </v-row>
  </v-card>
</template>

<script>

    export default {
        pageTitle: 'My Profile',
        data () {
            return {
                loading: false,
                form: {
                    firstName: 'John',
                    lastName: 'Doe',
                    contactEmail: 'john@doe.com',
                    avatar: 'MALE_CAUCASIAN_BLOND_BEARD'
                },
                showAvatarPicker: false
            }
        },
        methods: {
            openAvatarPicker () {
                this.showAvatarPicker = true
            },
            selectAvatar (avatar) {
                this.form.avatar = avatar
            }
        }
    }
</script>

<style scoped>
.set{
  margin-top: 120px;
}
</style>