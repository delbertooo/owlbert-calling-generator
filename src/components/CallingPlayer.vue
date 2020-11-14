<template>
    <div class="d-inline-block">
    <audio controls ref="player" class="player" loop>
      <source src="/owlbert.ogg" type="audio/ogg; codecs=vorbis"/>
      <source src="/owlbert.mp3" type="audio/mpeg"/>
    </audio>
    
    <v-btn elevation="2" icon v-on:click="play()">
      <v-icon v-if="playing">mdi-pause</v-icon>
      <v-icon v-else>mdi-play</v-icon>
    </v-btn>
    </div>
</template>

<script>
import { timer, from } from "rxjs";
import { concatMap, tap, finalize, takeWhile } from "rxjs/operators";
export default {
  name: "CallingPlayer",

  props: ['data'],

  data: () => ({
    playing: false,
  }),

  methods: {
    play() {
      if (this.playing) {
        this.playing = false
        this.$refs['player'].load()
        return
      }
      this.playing = true;
      from(this.data).pipe(
        concatMap(x => {
          if (x.type === 'sound') {
            this.$refs['player'].play()
          }
          return timer(Math.abs(x.duration))
        }),
        takeWhile(() => this.playing),
        tap(() => this.$refs['player'].load()),
        finalize(() => this.playing = false),
      ).subscribe()
    },
  },


};
</script>
