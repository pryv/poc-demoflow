<template>
  <div id="mainView">
    <split-pane v-on:resize="resize" :min-percent='50' :default-percent='50' split="vertical">
      <template slot="paneL">
        <Accesses :onSelectProp="onAccessSelect"/>
      </template>
      <template slot="paneR">
        <Data ref="dataView"/>
      </template>
    </split-pane>

  </div>
</template>

<script>

  import splitPane from 'vue-splitpane'
  import Accesses from './Accesses.vue'
  import Data from './Data.vue'

  export default {
    name: 'main',
    components: {
      Accesses,
      splitPane,
      Data
    },
    methods: {
      onEventLoaded: function () {

      },
      onAccessSelect: function (access) {
        console.log("*****", access);
        this.$refs.dataView.selectAccess(access);
      },
      resize() {
        console.log('resize')
      }
    }
  }
</script>
<!-- styling for the component -->
<style>
  #about {
    font-family: 'Roboto', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
  }
</style>
