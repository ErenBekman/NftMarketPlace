import colors from 'vuetify/es5/util/colors'

export default {
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    titleTemplate: '%s - NftMarketPlace',
    title: 'NftMarketPlace',
    htmlAttrs: {
      lang: 'en'
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },
  
  // Global CSS: https://go.nuxtjs.dev/config-css
  css: ["~/assets/scss/style.scss"],

  loading: {
    color: "DodgerBlue",
    height: "5px",
    continuous: true,
    duration: 3000
  },

  pageTransition: {
    name: "page",
    mode: "out-in"
  },

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    '~/plugins/vuetify.js',
    '~/plugins/web3.js',
    '~/plugins/alert.js',
    '~/plugins/Nft.js',
  ],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/vuetify
    '@nuxtjs/vuetify',
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    'vue-sweetalert2/nuxt',
    '@nuxtjs/auth-next',
    [
      'nuxt-fontawesome', {
        imports: [
         {
           set: '@fortawesome/free-solid-svg-icons',
           icons: ['fas']
         },
         {
           set:'@fortawesome/free-brands-svg-icons',
           icons: ['fab']
         }
       ]
      }
]
  ],

  auth: {
    strategies: {
      local: {
        token: {
          property: 'access_token',
          maxAge: 0,
          // required: true,
          // type: 'Bearer'
        },
        endpoints: {
          login: { url: 'http://nft-backend.test/api/login', method: 'post' },
          logout: { url: 'http://nft-backend.test/api/logout', method: 'post' },
          user: { url: 'http://nft-backend.test/api/user', method: 'get' }
        },
        user: {
          property: false,
          // autoFetch: true
        },
      },
    },
    redirect: {
      login: '/auth/login',
      logout: '/',
      callback: '/auth/login',
      home: '/'
    }
  },

  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    baseURL: 'http://nft-backend.test/api',
    // credentials:true,
    // proxy: true 
    proxyHeaders: false,
    credentials: false
  },
  proxy: {
    '/api': {
      target: 'http://nft-backend.test/api',
      pathRewrite: { '^/api': '/' }
    }
  },

  // Vuetify module configuration: https://go.nuxtjs.dev/config-vuetify


  // vuetify: {
  //   customVariables: ['~/assets/variables.scss'],
  //   theme: {
  //     light: true,
  //     themes: {
  //       dark: {
  //         primary: colors.blue.darken2,
  //         accent: colors.grey.darken3,
  //         secondary: colors.amber.darken3,
  //         info: colors.teal.lighten1,
  //         warning: colors.amber.base,
  //         error: colors.deepOrange.accent4,
  //         success: colors.green.accent3
  //       },
  //       light: {
  //         primary: "#316ce8",
  //         accent: "#607df9",
  //         secondary: "#a73aeb",
  //         info: "#0164d3",
  //         warning: "#fec500",
  //         error: "#ff4d7e",
  //         success: "#2cdd9b"
  //       }
  //     }
  //   }
  // },
  vuetify: {
    customVariables: ["~/assets/scss/variables.scss"],
    optionsPath: "./vuetify.options.js",
    treeShake: true,
    options: {
      customProperties: true
    }
  },


  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
  }
}
