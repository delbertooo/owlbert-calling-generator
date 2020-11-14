<template>
    <v-row>
      <v-col cols="12">
        [
        <span class="mx-2" v-for="(d, index) in data" :key="index">
          <span>{{d.duration}}</span>
          <span v-if="index + 1 < data.length">, </span>
        </span>
        ]
      </v-col>
    </v-row>
</template>

<script>
export default {
  name: "Calling",

  props: ['data'],
};
</script>
