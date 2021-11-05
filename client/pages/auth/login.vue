<template>
    <v-container class="y justify-center">
      <v-flex xs12 class="text-xs-center" mt-5>
        <h1 class="text-center mt-14">Sign In</h1>
      </v-flex>
        <v-row>
            <v-col cols="6" class="pa-md-4 mx-auto">
                    <v-form
                    ref="form"
                    v-model="valid"
                    lazy-validation
                >
                    <v-text-field
                    v-model="form.email"
                    :rules="emailRules"
                    label="E-mail"
                    required
                    ></v-text-field>

                    <v-text-field
                    v-model="form.password"
                    :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                    :rules="[rules.required, rules.min]"
                    :type="show1 ? 'text' : 'password'"
                    name="input-10-1"
                    label="Password"
                    hint="At least 6 characters"
                    counter
                   @click:append="show1 = !show1"
                    required
                    ></v-text-field>

                    <v-checkbox
                    v-model="checkbox"
                    :rules="[v => !!v || 'You must agree to continue!']"
                    label="Do you agree?"
                    required
                    ></v-checkbox>

                    <v-btn
                    :disabled="!valid"
                    class="mr-4"
                    block
                    @click="login"
                    >
                    SIGN IN
                    </v-btn>

                </v-form>
            </v-col>
        </v-row>
    </v-container>
</template>


<script>
  export default {
    // middleware:  ['guest'],
    data: () => ({
      show1: false,
      valid: true,
      rules: {
          required: value => !!value || 'Required.',
          min: v => v.length >= 6 || 'Min 6 characters',
          emailMatch: () => (`The email and password you entered don't match`),
        },
      emailRules: [
        v => !!v || 'E-mail is required',
        v => /.+@.+\..+/.test(v) || 'E-mail must be valid',
      ],
      select: null,
      checkbox : false,
      form :{
        email : '',
        password : '',
        device_name: 'nuxt'
      }

    }),

    methods: {
      async login () {
        this.$refs.form.validate()
        await this.$auth.loginWith('local' , {data:this.form})
        //  await this.$axios.$post('http://nft-backend.test/api/login', this.form)
        .then(response => {
            // localStorage.setItem("token", response.data);
            // this.$router.push('/')
        })
      },

    },
  }
</script>

<style scoped>
.y{
  margin-top: 200px;
}
</style>