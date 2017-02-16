<template>
  <q-pull-to-refresh :handler="refresh" class="games">
    <q-infinite-scroll class="justify-center" ref="infiniteScroll" :handler="loadMore">
      <div class="list item-inset-delimiter highlight" id="scrollArea">
        <game-item v-for="game in games" :game="game"></game-item>
      </div>
      <spinner slot="message" :size="40"></spinner>
    </q-infinite-scroll>
  </q-pull-to-refresh>
</template>

<script>
  import axios from 'axios'
  import { Toast, Utils } from 'quasar'
  import GameItem from 'components/GameItem.vue'
  export default {
    components: {
      GameItem
    },
    computed: {
      games () {
        return this.$store.state.games
      }
    },
    created () {
      this.$bus.$on('search-games', () => { this.searchGames() })
    },
    methods: {
      refresh (callback) {
        this.loadMore(1, callback)
      },
      searchGames () {
        var element = document.getElementById('scrollArea')
        Utils.dom.setScrollPosition(Utils.dom.getScrollTarget(element), 0, 200)
        this.loadMore()
      },
      loadMore (page = 1, callback = null) {
        let options = {
          headers: {
            'Content-Type': 'application/json'
          },
          params: {
            query: this.$store.state.query,
            page: page
          }
        }
        // let url = '/api/games'
        let url = 'http://gamejam.dev/api/games'
        axios.get(url, options).then(response => {
          if (page === 1) {
            this.$store.commit('clearGames')
          }
          this.$store.commit('addGames', response.data)
          if (page === 1 && this.games.length === 0) {
            Toast.create.warning('No games found.')
          }
          if (callback) {
            callback(response.data.length < 100)
          }
        })
      }
    }
  }
</script>

<style lang="styl">
  .games .q-spinner
    margin: auto
    display: block
    margin-top: 20px
    margin-bottom: 20px
</style>
