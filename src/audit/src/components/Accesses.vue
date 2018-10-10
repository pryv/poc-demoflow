<template>
  <table border="1">
    <tr>
      <th>name</th><th>username</th>
    </tr>

    <tr v-for="access in accesses">
      <td>
        {{ access.name }}
      </td>
      <td>
        {{ access.token }}
      </td>
    </tr>
  </table>
</template>


<script>




  export default {
    name: 'Accesses',
    data () {
      return {
        username: window.pryvUsername,
        UserInput :'',
        accesses: this.accesses
      }

    },
    computed: {
      accesses() {
        return this.accesses;
      }
    },
    created () {
      var that = this;
      window.pryvConnection.accesses.get(function (err, res ) {
          console.log(JSON.stringify(res));
          if (res) {
            that.accesses = res;
          }
      });
    },
    methods:{
      GoToRoute : function(){
        this.$router.push({ name: 'Paramdetails', params: { id: this.UserInput }})
      }
    }
  }
</script>
