<template>
  <q-layout>
    <div slot="header" class="toolbar">
      <q-toolbar-title :padding="0">
        GameJam
      </q-toolbar-title>
    </div>
    <div class="layout-view">
    </div>
  </q-layout>
</template>

<script>
  import axios from 'axios'
  export default {
    data () {
      return {
        games: []
      }
    },
    mounted () {
      let options = {
        headers: { 'Content-Type': 'application/json' }
      }
      // let url = '/api/games'
      let url = 'http://gamejam.dev/api/games'
      axios.get(url, options).then(response => {
        console.log(response)
        this.games = response.data
      }, error => {
        console.error(error)
      })
    },
    methods: {
    }
  }
</script>

<style lang="styl">
</style>
