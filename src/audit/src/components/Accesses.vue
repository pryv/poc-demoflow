<template>
  <table border="1">
    <tr>
      <th v-for="field in fields">
        {{ field.title }}
      </th>
    <tr>

    <tr v-for="access in accesses">
      <td v-for="field in fields">
        {{ field.display(access) }}
      </td>
    </tr>
  </table>
</template>


<script>

  var accessesMap = {};


  function displayType (access) {
    if (access.type === 'shared') return 'Sharing';
    if (access.type === 'app') {
      if (access.name.startsWith('cm-')) return 'Consent';
      return 'Device & App';
    }
    if (access.type == 'personal') return 'Management tools';
    return 'Unknown';
  }

  function displayRaw (key) {
    return function (access) {
      return access[key];
    }
  }

  function displayDate (key) {
    return function (access) {
      var date = new Date(access[key] * 1000);
      return date.toLocaleString();
    }
  }

  function displayBy (key) {
    return function (access) {
      if (access[key] === 'system') return 'System or Owner';
      if (accessesMap[access[key]]) {
        return accessesMap[access[key]].name;
      }
      return accessesMap[access[key]];
    }
  }

  function modifiedDate (access) {
    if (access.modified !== access.created) return displayDate('modified')(access);
    return '-';
  }

  function modifiedBy(access) {
    if (access.modifiedBy !== access.createdBy) return displayBy('modified')(access);
    return '-';
  }

  const fields = [
    {
      key: 'name',
      title: 'Name',
      display: displayRaw('name')
    },
    {
      key: 'type',
      title: 'Type',
      display: displayType
    },
    {
      key: 'lastUsed',
      title: 'Last Usage',
      display: displayDate('lastUsed')
    },
    {
      key: 'created',
      title: 'Creation Date',
      display: displayDate('created')
    },
    {
      key: 'createdBy',
      title: 'Created By',
      display: displayBy('createdBy')
    },
    {
      key: 'modified',
      title: 'Modification Date',
      display: modifiedDate
    },
    {
      key: 'modifiedBy',
      title: 'Modified By',
      display: modifiedBy
    }
  ]


  export default {
    name: 'Accesses',
    data () {
      return {
        username: window.pryvUsername,
        UserInput :'',
        accesses: this.accesses,
        fields: fields
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
            that.accesses.forEach(function (access) {
              accessesMap[access.id] = access;
            });
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
