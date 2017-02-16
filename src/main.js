// require(`./themes/app.${__THEME}.styl`)
require(`quasar/dist/quasar.${__THEME}.css`)
require(`assets/flags.css`)

import Vue from 'vue'
import Quasar from 'quasar'
import store from './store'
import router from './router'

Vue.use(Quasar)

Object.defineProperty(Vue.prototype, '$bus', {
  get () {
    return this.$root.bus
  }
})

Quasar.start(() => {
  /* eslint-disable no-new */
  new Vue({
    el: '#q-app',
    data: { bus: new Vue({}) },
    store,
    router,
    render: h => h(require('./App'))
  })
})
