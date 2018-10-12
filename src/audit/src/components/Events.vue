<template>
  <v-data-table
    v-model="selected"
    :headers="fields"
    :items="events"
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

  var eventsMap = {};


  function displayType (event) {
    return event.type;
  }

  function displayRaw (key) {
    return function (event) {
      return event[key];
    }
  }

  function displayDate (key) {
    return function (event) {
      var date = new Date(event[key] * 1000);
      return date.toLocaleString();
    }
  }



  function displayPermission(event) {
    if (event.type === 'personal') return 'System or Owner';
    return event.permissions;
  }

  function displayStream(event) {
    return event.stream.name;
  }

  function displayTags(event) {
    if (!event.tags || event.tags.length == 0) return '-';
    return JSON.stringify(event.tags);
  }

  function displayAction(event) {
    if (event.deleted) return 'Delete';
    if (event.trashed) return 'Trashed';
    if (event.created === event.modified) return 'Create';
    return 'Modify';
  }

  function displayAttachments(event) {
    if (!event.attachments || event.attachments.length == 0) return '-';
    var res = '<li>';
    event.attachments.forEach(function (attachment) {
      res += '<el><a target="_new" href="' + event.attachmentUrl(attachment) + '">' + attachment.fileName + '</a></el>';
    });
    return res + '</li>';
  }

  const fields = [
    {
      key: 'modified',
      title: 'Action Date',
      display: displayDate('modified'),
    },
    {
      key: 'action',
      title: 'Action',
      display: displayAction
    },
    {
      key: 'streamId',
      title: 'Stream',
      display: displayStream
    },
    {
      key: 'eventType',
      title: 'Type',
      display: displayType
    }
    ];

  const details = [
    {
      key: 'content',
      title: 'Content',
      display: displayRaw('content')
    },
    {
      key: 'tags',
      title: 'Tags',
      display: displayTags
    },
    {
      key: 'attachments',
      title: 'Attachments',
      display: displayAttachments
    }
  ];

  var selectedItem = null;

  export default {
    name: 'events',
    props: [
      'onSelectProp'
    ],
    data () {
      return {
        username: window.pryvUsername,
        UserInput :'',
        events: this.events,
        fields: fields,
        details: details,
        pagination: {
          sortBy: 'name',
          rowsPerPage: 15

        },
        selected: []
      }

    },
    computed: {

    },
    created () {
      this.events = [];
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
        console.log('events selected ' + item.name + ' > ' + item.id);
      },
      setEvents (events) {
        this.events = events;
      }
    }
  }



</script>
