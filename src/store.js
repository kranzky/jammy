import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  strict: true,
  state: {
    games: [],
    query: ''
  },
  mutations: {
    updateQuery (state, value) {
      state.query = value
    },
    clearGames (state) {
      state.games.length = 0
    },
    addGames (state, games) {
      state.games.push.apply(state.games, games)
    }
  }
})
