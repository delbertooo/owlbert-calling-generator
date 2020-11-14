<template>
  <v-app>
    <v-app-bar
      app
      color="primary"
      dark
    >
      <v-toolbar-title>Owlbert CaGe</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn
        href="https://github.com/delbertooo/owlbert"
        target="_blank"
        text
      >
        <span class="mr-2">Owlbert</span>
        <v-icon>mdi-open-in-new</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main>
      <Generator/>
    </v-main>
  </v-app>
</template>

<script>
import Generator from './components/Generator';

export default {
  name: 'App',

  components: {
    Generator,
  },

  data: () => ({
    //
  }),
};
</script>
