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
          <H3>{{ access.name }}</H3>
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
