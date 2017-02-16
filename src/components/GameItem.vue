<template>
  <div class="game item three-lines">
    <img class="item-primary responsive thumbnail shadow-3" :src="game.image">
    <div class="item-content has-secondary">
      <div>{{ game.name }}</div>
      <div>{{ game.description }}</div>
    </div>
    <div class="item-secondary stamp">
      <div class="details">
        <img :class="flag" :alt="game.country" src="statics/blank.png">
      </div>
    </div>
    <div class="item-secondary stamp">
      <div class="details">
        {{game.year}}
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    props: ['game'],
    computed: {
      flag () {
        return `flag flag-${this.game.country.toLowerCase()}`
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
  .game.item .stamp .details
    display: block
    margin: auto
    width: 32px
    text-align: center
</style>
