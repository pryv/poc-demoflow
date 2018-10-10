<template>
  <div id="app">
    <div v-if="username == null">
      Missing username or valid token
    </div>
    <div v-else>
      Audit for user: {{username}}
      <router-link v-bind:to="'/'">Home</router-link>
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'app',
    data () {
      window.pryvUsername =  this.$route.query.username || null;
      console.log("*" + window.pryvUsername  + "*");
      return {
        username: this.$route.query.username
      }
    }
  }
</script>
<!-- styling for the component -->
<style>
  #app {
    font-family: 'Roboto', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
  }
</style>
