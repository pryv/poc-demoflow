<template>
  <div id="app">
    <div v-if="username == null">
      Missing pryvApiEndpoint
    </div>
    <div v-else>
      <div v-if="state == 'loading'">
        Loading ...
      </div>
      <div v-else>
        <div v-if="state == 'nok'">
          Failed
        </div>
        <div v-else>
          Audit for user: {{username}}
          <router-link v-bind:to="'./'">Accesses</router-link>
          <router-view></router-view>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Pryv from 'pryv';

  export default {
    name: 'app',
    data () {
    

      console.log("*" + window.pryvUsername  + "*");
      return {
        username: window.pryvUsername,
        state2: 'loading'
      }
    },
    computed: {
      state() {
        return this.state2
      }
    },
    async created () {
      
        window.pryvApiEndpoint =  this.$route.query.pryvApiEndpoint || null;
      if (window.pryvApiEndpoint == null) {
        console.error('pryvApiEndpoint is not set');

      }
      const pryvConnection = new Pryv.Connection(window.pryvApiEndpoint);
      window.pryvConnection = pryvConnection;
      window.pryvUsername = await pryvConnection.username();
      this.username = window.pryvUsername;
      
      this.state2 = 'ok';
      console.log('ok', pryvConnection);
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
