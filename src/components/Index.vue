<template>
  <q-layout>
    <div slot="header" class="toolbar">
      <q-search v-model="query" @input="searchGames"></q-search>
    </div>
    <div class="layout-view">
      <q-pull-to-refresh :handler="refresh" class="games">
        <q-infinite-scroll class="justify-center" ref="infiniteScroll" :handler="loadMore">
          <div class="list item-inset-delimiter highlight" id="scrollArea">
            <div class="game item three-lines" v-for="game in games">
              <img class="item-primary responsive thumbnail" :src="game.image">
              <div class="item-content has-secondary">
                <div>{{ game.name }}</div>
                <div>{{ game.description }}</div>
              </div>
              <div class="item-secondary stamp">
                {{ game.year }}
              </div>
              <div class="item-secondary stamp">
              	<img class="flag flag-au" alt="AU" src="statics/blank.png">
              </div>
            </div>
          </div>
          <spinner slot="message" :size="40"></spinner>
        </q-infinite-scroll>
      </q-pull-to-refresh>
      <button v-back-to-top.animate="{ duration: 200 }" class="primary circular fixed-bottom-right animate-pop" style="margin: 0 15px 15px 0">
        <i>keyboard_arrow_up</i>
      </button>
    </div>
  </q-layout>
</template>

<script>
  import axios from 'axios'
  import { Toast, Utils } from 'quasar'
  export default {
    data () {
      return {
        games: [],
        query: ''
      }
    },
    mounted () {
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
            query: this.query,
            page: page
          }
        }
        // let url = '/api/games'
        let url = 'http://gamejam.dev/api/games'
        axios.get(url, options).then(response => {
          if (page === 1) {
            this.games = []
          }
          this.games.push.apply(this.games, response.data)
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
  .game.item .item-content
    margin-left: 120px
  .game.item:after
    margin-left: 50px
  .game.item .thumbnail
    width: 90px
    height: auto
  .games .q-spinner
    margin: auto
    display: block
    margin-top: 20px
    margin-bottom: 20px
</style>
