<template>
  <div id="main">
   <Accesses/>
  </div>
</template>

<script>
  import Accesses from './Accesses.vue'
  export default {
    name: 'main',
    components: {
      Accesses
    }
  }
</script>
<!-- styling for the component -->
<style>
  #about {
    font-family: 'Roboto', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
  }
</style>
