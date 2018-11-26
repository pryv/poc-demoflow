<template>
  <div id="data">
    <div v-if="state == 'loading'">
      Loading ...
    </div>
    <div v-else>
      <div v-if="state == 'nok'">
        Failed
      </div>
      <div v-else>
        Details
        <div v-if="access">
              <div class="headline">{{ access.name }}</div>

                <ol v-for="detail in details">
                  <li v-if="detail.display(access) !== '-'"
                      class="grey--text"
                      style="white-space:nowrap; text-align: center;"><B>{{ detail.title }}</B> &mdash; {{ detail.display(access)}}</li>
                </ol>

        </div>
        <div v-else>
          <H3>-</H3>
        </div>
        <Events ref="eventsView"/>
      </div>
    </div>
  </div>
</template>


<script>
  // ----- Access detail ------ //
  const details = [
    {
      key: 'permission',
      title: 'Permissions',
      display: displayPermission,
    },
    {
      key: 'clientData',
      title: 'Informations',
      display: displayClientData,
    },
    {
      key: 'created',
      title: 'Creation Date',
      display: displayDate('created')
    },
    {
      key: 'createdBy',
      title: 'Created By',
      display: displayRaw('createdByName')
    },
    {
      key: 'modified',
      title: 'Modification Date',
      display: modifiedDate,
    },
    {
      key: 'modifiedBy',
      title: 'Modified By',
      display:  displayRaw('modifiedByName'),
    }
  ];

  function displayDate (key) {
    return function (access) {
      var date = new Date(access[key] * 1000);
      return date.toLocaleString();
    }
  }

  function displayRaw (key) {
    return function (access) {
      return access[key];
    }
  }


  function displayClientData (access) {
    if (access.clientData) return access.clientData;
    return '-';
  }


  function modifiedDate (access) {
    if (access.modified !== access.created) return displayDate('modified')(access);
    return '-';
  }

  function modifiedBy(access) {
    if (access.modifiedBy !== access.createdBy) return displayBy('modified')(access);
    return '-';
  }

  function displayPermission(access) {
    if (access.type === 'personal') return 'System or Owner';
    return access.permissions;
  }

  // ----- Events ------------- //
  import Events from './Events.vue'

  var eventsCache = null;
  var eventsMap = {}; // by modifiedBy
  export default {
    name: 'Data',
    props: [

    ],
    components: {
      Events
    },
    data () {
      return {
        access: this.selectedAccess,
        connection: this.connection,
        state: 'loading',
        details: details
      }
    },
    computed: {

    },
    created () {
      this.access = null;
      this.connection =  window.pryvConnection;
      this.state = 'loading';
      var that = this;
      this.connection.events.get({
        limit: 10000,
        includeDeletions: true,
        modifiedSince: ((new Date().getMilliseconds() / 1000) - 60*60*24*100)
      }, function (error, events) {
        if (error) {
          that.state = 'nok';
        } else {
          eventsCache = events;
          eventsCache.forEach(function(event) {
            var modifiedBy = event.modifiedBy;
            if (! eventsMap[modifiedBy]) eventsMap[modifiedBy] = [];
            eventsMap[modifiedBy].push(event);
          });
          that.state = 'ok';
        }
      });
    },
    methods:{
      selectAccess : function(access){
        this.access = access;
        this.$refs.eventsView.setEvents(this.eventsForAccess(access));
        console.log('Data selected Access:' + access.name);
      },
      eventsForAccess: function(access) {
        if (this.access === null || (! eventsMap) || (! eventsMap[access.id])) return [];
        return eventsMap[access.id];
      }
    }
  }



</script>
