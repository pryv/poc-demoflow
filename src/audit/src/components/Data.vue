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
                      style="white-space:nowrap; text-align: center;"><B>{{ detail.title }}</B> &mdash; <span v-html="detail.display(access)"/></li>
                </ol>

        </div>
        <div v-else>
          <H3>-</H3>
        </div>
        <Audit ref="auditView"/>
      </div>
    </div>
  </div>
</template>


<script>


  import marked from 'marked';
  import request from 'superagent';

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
    return access.permissions;
  }

  // ----- Audit ------------- //
  import Audit from './Audit.vue'

  var auditLogsCache = null;
  var auditLogsMap = {}; // by accessId
  export default {
    name: 'Data',
    props: [

    ],
    components: {
      Audit
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

      const connectionSettings = this.connection.settings;
      const auth = connectionSettings.auth;
      const username = connectionSettings.username;
      const domain = connectionSettings.domain;

      request
        .get(`https://${username}.${domain}/audit/logs`)
        .set('Authorization', auth)
        .then(res => {
          auditLogsCache = res.body.auditLogs;
          auditLogsCache.forEach(function(auditLog) {
            const accessId = auditLog.accessId;
            if (! auditLogsMap[accessId]) auditLogsMap[accessId] = [];
            auditLogsMap[accessId].push(auditLog);
          });
          that.state = 'ok';
        })
        .catch(err => {
          console.log(err);
          that.state = 'nok';
        });
    },
    methods:{
      selectAccess : function(access){
        this.access = access;
        this.$refs.auditView.setAuditLogs(this.auditLogsForAccess(access));
        console.log('Data selected Access:' + access.name);
      },
      auditLogsForAccess: function(access) {
        if (this.access === null || (! auditLogsMap) || (! auditLogsMap[access.id])) return [];
        return auditLogsMap[access.id];
      }
    }
  }



</script>
