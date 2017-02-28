<template>
  <q-modal ref="gameDetails" v-if="game">
    <q-layout>
      <div slot="header" class="toolbar">
        <button @click="$refs.gameDetails.close()">
          <i>keyboard_arrow_left</i>
        </button>
        <q-toolbar-title>
          {{ game.name }}
        </q-toolbar-title>
      </div>
      <div class="layout-view">
        <div class="card info" ref="tab-info">
          <img :src="game.image" class="responsive">
          <div class="card-content">
            <p class="light-paragraph">{{ game.description }}</p>
          </div>
          <div class="card-actions">
            <div class="text-primary">
              <a :href="game.url" target="_blank">View Original <i>open_in_new</i></a>
            </div>
            <div class="auto"></div>
            <div class="text-grey-6">
              {{ game.country }}, {{ game.year }}
            </div>
          </div>
        </div>
        <div class="card video" ref="tab-video" v-if="hasVideo">
          <q-video :src="game.video"></q-video>
        </div>
        <div class="card play" ref="tab-play" v-if="hasGame">
          <q-slider fullscreen>
            <div slot="slide">
              <q-video :src="game.play"></q-video>
            </div>
          </q-slider>
        </div>
      </div>
      <div slot="footer" class="toolbar">
        <q-tabs :refs="$refs" default-tab="tab-info">
          <q-tab name="tab-info" icon="info_outline">Info</q-tab>
          <q-tab name="tab-video" icon="ondemand_video" v-if="hasVideo">Video</q-tab>
          <q-tab name="tab-play" icon="videogame_asset" v-if="hasGame">Play</q-tab>
        </q-tabs>
      </div>
    </q-layout>
  </q-modal>
</template>

<script>
  import Vue from 'vue'

  // TODO: select info tab by default
  // TODO: stop video/game when tab unselected or when modal closed
  // TODO: request slider fullscreen by default when game tab selected
  // TODO: autoplay video on select
  // TODO: show flag
  // TODO: URLs for sharing, and sharing button

  export default {
    data () {
      return {
        game: null
      }
    },
    created () {
      this.$bus.$on('show-game', (game) => { this.showGame(game) })
    },
    computed: {
      hasGame () {
        return this.game.embed && this.game.play
      },
      hasVideo () {
        return this.game.video
      }
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
  .modal-content
    width: 800px
    height: 70vh
    background-color: black
  .card.info
    background-color: white
  .q-slider
    background-color: black
    color: white
    .video
      height: 50vh
  .q-slider.fullscreen
    .video
      width: 100%
      height: 100vh
</style>
