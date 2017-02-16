<template>
  <q-layout>
    <div slot="header" class="toolbar">
      <q-search v-model="query" @input="triggerSearch"></q-search>
    </div>
    <div class="layout-view">
      <game-list></game-list>
      <button v-back-to-top.animate="{ duration: 200 }" class="primary circular fixed-bottom-right animate-pop" style="margin: 0 15px 15px 0">
        <i>keyboard_arrow_up</i>
      </button>
    </div>
  </q-layout>
</template>

<script>
  import GameList from 'components/GameList.vue'
  export default {
    components: {
      GameList
    },
    computed: {
      query: {
        get () {
          return this.$store.state.query
        },
        set (value) {
          this.$store.commit('updateQuery', value)
        }
      }
    },
    methods: {
      triggerSearch () {
        this.$bus.$emit('search-games')
      }
    }
  }
</script>

<style lang="styl">
</style>
