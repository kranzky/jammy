<template>
  <q-modal class="minimized" v-if="game">
    <h1>{{ game.name }}</h1>
  </q-modal>
</template>

<script>
  import Vue from 'vue'

  export default {
    data () {
      return {
        game: null
      }
    },
    created () {
      this.$bus.$on('show-game', (game) => { this.showGame(game) })
    },
    methods: {
      showGame (game) {
        this.game = game
        Vue.nextTick(() => {
          this.$children[0].open()
        })
      }
    }
  }
</script>

<style lang="styl">
</style>
