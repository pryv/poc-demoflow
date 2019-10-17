<template>
  <v-data-table
    v-model="selected"
    :headers="fields"
    :items="filteredAccesses()"
    :pagination.sync="pagination"
    select-all
    item-key="id"
    class="elevation-1"
  >
    <template slot="headers" slot-scope="props">
      <!-- Search field, deactivated for now (remove v-if to activate) -->
      <v-text-field
        v-if="false"
        v-model="search"
        append-icon="search"
        label="Filter by access id"
        single-line
        hide-details
      ></v-text-field>
      <tr>
        <th
          v-for="header in props.headers"
          :key="header.key"
          :class="['column sortable', pagination.descending ? 'desc' : 'asc', header.name === pagination.sortBy ? 'active' : '']"
          @click="changeSort(header.key)"
        >
          <v-icon small>arrow_upward</v-icon>
          {{ header.title }}
        </th>
      </tr>
    </template>
    <template slot="items" slot-scope="props">
      <tr :active="props.selected" @click="onSelect(props.item)">
        <td v-for="field in fields" class="text-xs-left">
          {{ field.display(props.item) }}
        </td>
      </tr>
    </template>
  </v-data-table>
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

  function displayDeleted(access) {
    if (access.deleted === null) return 'Expired';
    return 'Valid';
  }



  const fields = [
    {
      key: 'lastUsed',
      title: 'Last Usage',
      display: displayDate('lastUsed')
    },
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
      key: 'deleted',
      title: 'Status',
      display: displayDeleted
    }
    ];




  var selectedItem = null;

  export default {
    name: 'Accesses',
    props: [
      'onSelectProp'
    ],
    data () {
      return {
        search: '',
        username: window.pryvUsername,
        UserInput :'',
        accesses: this.accesses,
        fields: fields,
        pagination: {
          sortBy: 'lastUsed',
          descending: true,
          rowsPerPage: 10

        },
        selected: []
      }

    },
    computed: {

    },
    created () {
      var that = this;
      window.pryvConnection.accesses.get(function (err, res ) {
          if (res) {
            that.accesses = res;
            that.accesses.forEach(function (access) {
              accessesMap[access.id] = access;
            });
          }
      });
    },
    methods:{
      filteredAccesses: function() {
        if (this.search != null && this.search != '') {
          return this.accesses.filter((a) => {return a.id.includes(this.search)});
        }
        return this.accesses;
      },
      GoToRoute : function(){
        this.$router.push({ name: 'Paramdetails', params: { id: this.UserInput }})
      },
      changeSort (column) {
        if (this.pagination.sortBy === column) {
          this.pagination.descending = !this.pagination.descending
        } else {
          this.pagination.sortBy = column
          this.pagination.descending = false
        }
      },
      onSelect (item) {
        if (item === selectedItem) return;

        // add createdByName and modifiedByName
        item.createdByName = displayBy('createdBy')(item);
        item.modifiedByName = displayBy('modifiedBy')(item);

        selectedItem = item;


        if (this.onSelectProp) this.onSelectProp(selectedItem);
        console.log('Accesses selected ' + item.name + ' > ' + item.id);
      }
    }
  }



</script>
