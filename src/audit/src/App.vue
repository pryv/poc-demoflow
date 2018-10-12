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
  import Pryv from 'pryv';
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
      if (window.pryvUsername ) {
        var pryvConnection = new Pryv.Connection({
          username: window.pryvUsername,
          auth: this.$route.query.auth,
          domain: this.$route.query.domain ||'pryv.me',
        });
        var that = this;
        pryvConnection.fetchStructure(function (error, result) {
          if (result) {
            that.state2 = 'ok';
            console.log('ok');
            window.pryvConnection = pryvConnection;
          } else {
            that.state2 = 'nok';
          }
        });
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
