// require(`./themes/app.${__THEME}.styl`)
require(`quasar/dist/quasar.${__THEME}.css`)
require(`assets/flags.css`)

import Vue from 'vue'
import Quasar from 'quasar'
import router from './router'

Vue.use(Quasar)

Quasar.start(() => {
  /* eslint-disable no-new */
  new Vue({
    el: '#q-app',
    router,
    render: h => h(require('./App'))
  })
})
