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

                <ul v-for="detail in details">
                  <li v-if="detail.display(access) !== '-'"
                      class="grey--text"
                      style="white-space:nowrap; text-align: center;"><B>{{ detail.title }}</B> &mdash; <span v-html="detail.display(access)"/></li>
                </ul>

        </div>
        <div v-else>
          <H3>-</H3>
        </div>
        <Audit
          :auditLogs="auditLogs"/>
      </div>
    </div>
  </div>
</template>


<script>


  import marked from 'marked';

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
    },
    {
      key: 'deleted',
      title: 'Deleted',
      display:  displayDate('deleted'),
    },
    {
      key: 'expires',
      title: 'Expires',
      display:  displayDate('expires'),
    }
  ];

  function displayDate (key) {
    return function (access) {
      if (access[key] == null) return '-';
      var date = new Date(access[key] * 1000);
      return date.toLocaleString();
    }
  }

  function displayRaw (key) {
    return function (access) {
      return access[key] || '-';
    }
  }


  function displayClientData (access) {
    if (access.clientData) {
      if (access.clientData['app-web-auth:description']) {
        return  marked(access.clientData['app-web-auth:description'].content);
      }
      return marked(access.clientData);
    }
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
    return JSON.stringify(access.permissions, null, 2);
  }

  // ----- Audit ------------- //
  import Audit from './Audit.vue'

  export default {
    name: 'Data',
    props: [

    ],
    components: {
      Audit
    },
    data () {
      return {
        auditLogs: [],
        auditLogsMap: {}, // by accessId
        access: this.selectedAccess,
        connection: this.connection,
        state: 'loading',
        details: details,
      }
    },
    computed: {

    },
    async created () {
      this.access = null;
      this.connection =  window.pryvConnection;
      this.state = 'ok';
    },
    methods:{
      selectAccess : async function(access){
        console.log('Data selected Access:' + access.name);
        this.access = access;

        if (this.access == null || this.auditLogsMap == null) {
          return this.auditLogs = [];
        }
        if (this.auditLogsMap[access.id] != null) {
          return this.auditLogs = this.auditLogsMap[access.id];
        }

        this.state = 'loading';
        

        this.connection = window.pryvConnection;

        let res;
        try {
          res = await this.connection.getRaw('audit/logs', {streams: [':_audit:access-' + access.id] });
        } catch (error) {
          console.log(error);
          this.state = 'nok';
          return;
        }
        
        const logs = res.body.auditLogs;
        console.log('Audit data:', logs);
        this.auditLogsMap[access.id] = logs;
        this.auditLogs = logs;
        this.state = 'ok';
      }
    }
  }
</script>
