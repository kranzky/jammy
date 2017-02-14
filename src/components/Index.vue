<template>
  <q-layout>
    <div slot="header" class="toolbar">
      <q-toolbar-title>
        Jammy Browser
      </q-toolbar-title>
    </div>
    <div class="layout-view">
      <q-pull-to-refresh :handler="refresh" class="games">
        <q-infinite-scroll class="justify-center" ref="infiniteScroll" :handler="loadMore">
          <div class="list item-inset-delimiter highlight">
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
                <div>{{ game.country }}</div>
              </div>
            </div>
          </div>
          <spinner slot="message" :size="40"></spinner>
        </q-infinite-scroll>
      </q-pull-to-refresh>
      <button v-back-to-top.animate="{offset: 500, duration: 200}" class="primary circular fixed-bottom-right animate-pop" style="margin: 0 15px 15px 0">
        <i>keyboard_arrow_up</i>
      </button>
    </div>
  </q-layout>
</template>

<script>
  // TODO: flags
  // TODO: implement search and filters
  // TODO: implement login (twitter) and ratings and sort by rating and apps // I've rated filter
  // TODO: implement popup on click
  // TODO: finish scraping
  // TODO: shipit
  import axios from 'axios'
  export default {
    data () {
      return {
        games: []
      }
    },
    mounted () {
    },
    methods: {
      refresh (callback) {
        this.games = []
        this.loadMore(1, callback)
      },
      loadMore (page, callback) {
        let options = {
          headers: { 'Content-Type': 'application/json' },
          params: { page: page }
        }
        // let url = '/api/games'
        let url = 'http://gamejam.dev/api/games'
        axios.get(url, options).then(response => {
          this.games.push.apply(this.games, response.data)
          callback(response.data.length < 100)
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
</style>
