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



  function displayDate (auditLog) {
    const date = new Date(auditLog.time * 1000);
    return date.toLocaleString();
  }



  function displayAction(auditLog) {
    return auditLog.content && auditLog.content.action || auditLog.action;
  }

  function displaySource(auditLog) {
    return auditLog.content && auditLog.content.source || auditLog.forwardedFor;
  }

  function displayQuery(auditLog) {
    return auditLog.content && auditLog.content.query;
  }

  function displayOthers(auditLog) {
    const others = Object.assign({}, auditLog);
    Object.assign(others, auditLog.content);
    delete others.content;
    delete others.time;
    delete others.created;
    delete others.modified;
    delete others.modifiedBy;
    delete others.streamIds;
    delete others.query; 
    delete others.action;
    delete others.source;
    let res = '';
    for (const key of Object.keys(others)) {
      res += '<BR>&nbsp;<B>' + key + ': </B>' + others[key] ;
    }
    return res;
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
      key: 'source',
      title: 'Source',
      display: displaySource
    }
    ];

  const details = [
   {
      title: 'query',
      key: 'query',
      display: displayQuery
    },
    {
      title: 'Others',
      key: 'others',
      display: displayOthers
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
          sortBy: 'time',
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
