<template>
  <v-container>
    <v-row class="text-center">

      <v-col class="mb-4" cols="12">
        <h1 class="display-2 font-weight-bold">
          Hit <span class="keybind">SPACE</span> to conduct callings.
        </h1>
      </v-col>

      <v-col class="mb-5" cols="12">
        callings here plz!
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
  export default {
    name: 'Generator',

    data: () => ({
      callings: [],
    }),
  }
</script>

<style>
.keybind {
  background: #d9d9d9;
  font-size: 80%;
  font-family: monospace;
  vertical-align: bottom;
}
.keybind::before {
  content: '[';
}
.keybind::after {
  content: ']';
}
</style>