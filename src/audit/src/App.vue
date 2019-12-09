<template>
  <div id="app">
    <div v-if="username == null">
      Missing username or valid token
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
  export default {
    name: 'app',
    data () {
      console.log("*" + window.pryvUsername  + "*");
      return {
        username: this.$route.query.username,
        state2: 'loading'
      }
    },
    computed: {
      state() {
        return this.state2
      }
    },
    created () {
      window.pryvUsername =  this.$route.query.username || null;
      if (window.pryvUsername == null) {
        console.error('username is not set');
        return;
      }
      const pryvConnection = {
        'settings': {
          'auth': this.$route.query.auth,
          'username': window.pryvUsername,
          'serviceInfoUrl': this.$route.query.serviceInfoUrl
        }
      };

      window.pryvConnection = pryvConnection;
      this.state2 = 'ok';
      console.log('ok');
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
