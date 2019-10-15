<template>
  <v-data-table
    v-model="selected"
    :headers="fields"
    :items="auditLogs"
    :pagination.sync="pagination"
    select-all
    item-key="id"
    class="elevation-1"
  >
    <template slot="headers" slot-scope="props">
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
      <tr :active="props.selected" @click="props.expanded = !props.expanded; onSelect(props.item)">
        <td v-for="field in fields" class="text-xs-left">
          {{ field.display(props.item) }}
        </td>
      </tr>
    </template>
    <template slot="expand" slot-scope="props">
      <v-card flat>
        <v-list two-line>
          <template v-for="detail in details">
            <v-list-tile v-if="detail.display(props.item) !== '-'">
              <v-list-tile-content class='text--primary'>{{ detail.title }}</span><span v-html="detail.display(props.item)"/>
              </v-list-tile-content>
            </v-list-tile>
          </template>
        </v-list>
        <v-card-text></v-card-text>
      </v-card>
    </template>
  </v-data-table>

</template>


<script>

  var auditLogsMap = {};

  function displayRaw(auditLog) {
    return auditLog;
  }

  function displayDate (auditLog) {
    var date = new Date(auditLog.time * 1000);
    return date.toLocaleString();
  }

  function displayStatus(auditLog) {
    return auditLog.status;
  }

  function displayAction(auditLog) {
    return auditLog.action;
  }

  const fields = [
    {
      key: 'date',
      title: 'Date',
      display: displayDate,
    },
    {
      key: 'action',
      title: 'Action',
      display: displayAction
    },
    {
      key: 'status',
      title: 'Status',
      display: displayStatus
    }
    ];

  const details = [
    {
      key: 'content',
      display: displayRaw
    }
  ];

  var selectedItem = null;

  export default {
    name: 'auditLogs',
    props: [
      'onSelectProp'
    ],
    data () {
      return {
        username: window.pryvUsername,
        UserInput :'',
        auditLogs: this.auditLogs,
        fields: fields,
        details: details,
        pagination: {
          sortBy: 'date',
          descending: true,
          rowsPerPage: 9

        },
        selected: []
      }

    },
    computed: {

    },
    created () {
      this.auditLogs = [];
    },
    methods:{
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
        selectedItem = item;
        if (this.onSelectProp) this.onSelectProp(selectedItem);
        console.log('audit log selected ' + item.id);
      },
      setAuditLogs (auditLogs) {
        this.auditLogs = auditLogs;
      }
    }
  }

</script>
