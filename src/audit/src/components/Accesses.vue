<template>
  <table border="1">
    <tr>
      <th>name</th><th>username</th>
    </tr>

    <tr v-for="user in users">
      <td>
        {{ user.name }}
      </td>
      <td>
        {{ user.username }}
      </td>
    </tr>
  </table>
</template>


<script>


  let users = [
    {
      name: 'Chris',
      username: 'chrisoncode',
      avatar: 'https://pbs.twimg.com/profile_images/850147482117865472/O28qQSrN_400x400.jpg'
    },
    {
      name: 'Nick',
      username: 'whatnicktweets',
      avatar: 'https://pbs.twimg.com/profile_images/502500686588690432/wXBzuCBj_400x400.jpeg'
    },
    {
      name: 'Holly',
      username: 'hollylawly',
      avatar: 'https://pbs.twimg.com/profile_images/926258409552297985/Vk18Dg9M_400x400.jpg'
    }
  ];


  export default {
    name: 'Accesses',
    data () {
      return {
        username: window.pryvUsername,
        UserInput :'',
        users: users
      }

    },
    created () {
      window.pryvConnection.accesses.get(function (err, res ) {
          console.log(JSON.stringify(res));
      });
    },
    methods:{
      GoToRoute : function(){
        this.$router.push({ name: 'Paramdetails', params: { id: this.UserInput }})
      }
    }
  }
</script>
