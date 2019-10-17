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
    <template slot="headers" slot-scope="properties">
      <tr>
        <th
          v-for="header in properties.headers"
          :key="header.key"
          :class="['column sortable', pagination.descending ? 'desc' : 'asc', header.name === pagination.sortBy ? 'active' : '']"
          @click="changeSort(header.key)"
        >
          <v-icon small>arrow_upward</v-icon>
          {{ header.title }}
        </th>
      </tr>
    </template>
    <template slot="items" slot-scope="properties">
      <tr :active="properties.selected" @click="properties.expanded = !properties.expanded; onSelect(properties.item)">
        <td v-for="field in fields" class="text-xs-left">
          {{ field.display(properties.item) }}
        </td>
      </tr>
    </template>
    <template slot="expand" slot-scope="properties">
      <v-card flat>
        <v-card-text></v-card-text>
        <ul v-for="detail in details">
          <li v-if="detail.display(properties.item)"
              class="grey--text"
              style="white-space:nowrap; text-align: left;">
              <B>{{ detail.title }}</B> &mdash; <span v-html="detail.display(properties.item)"/>
          </li>
        </ul>
        <v-card-text></v-card-text>
      </v-card>
    </template>
  </v-data-table>

</template>


<script>

  let auditLogsMap = {};
  const HttpStatus = require('http-status-codes');

  function displayRaw(prop) {
    return function(auditLog) {
      return auditLog[prop];
    };
  }

  function displayDate (auditLog) {
    const date = new Date(auditLog.time * 1000);
    return date.toLocaleString();
  }

  function displayHTTPStatus(auditLog) {
    return auditLog.status;
  }

  function displayStatus(auditLog) {
    try {
      const status = HttpStatus.getStatusText(auditLog.status);
      return status;
    } catch (err) {
      return auditLog.status;
    }
  }

  function displayAction(auditLog) {
    const action = auditLog.action;
    const resource = action.substring(action.indexOf("/") + 1);

    const method = auditLog.action.split(' ')[0];
    let verb;
    switch(method) {
      case 'GET':
        verb = 'Retrieve';
        break;
      case 'POST':
        verb = 'Create';
        break;
      case 'PUT':
        verb = 'Modify';
        break;
      case 'DELETE':
        verb = 'Delete';
        break;
      default:
        verb = method;
    }
    return `${verb}: ${resource}`;
  }

  const fields = [
    {
      key: 'time',
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
      title: 'Action id',
      key: 'actionId',
      display: displayRaw('id')
    },
    {
      title: 'Timestamp',
      key: 'timestamp',
      display: displayRaw('time')
    },
    {
      title: 'Client IP',
      key: 'clientIp',
      display: displayRaw('forwardedFor')
    },
    {
      title: 'Query',
      key: 'query',
      display: displayRaw('query')
    },
    {
      title: 'Access id',
      key: 'accessId',
      display: displayRaw('accessId')
    },
    {
      title: 'HTTP status',
      key: 'httpStatus',
      display: displayHTTPStatus
    },
    {
      title: 'Error message',
      key: 'errorMsg',
      display: displayRaw('errorMessage')
    },
    {
      title: 'Error id',
      key: 'errorId',
      display: displayRaw('errorId')
    }
  ];

  let selectedItem = null;

  export default {
    name: 'auditLogs',
    properties: [
      'onSelectProp'
    ],
    props: {
      auditLogs: {type: Array, default: []},
    },
    data () {
      return {
        username: window.pryvUsername,
        UserInput :'',
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
      }
    }
  }

</script>
