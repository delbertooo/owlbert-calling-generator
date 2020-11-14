<template>
    <div class="d-inline-block">
    <audio controls ref="player" class="player" loop>
      <source src="/owlbert.ogg" type="audio/ogg; codecs=vorbis"/>
      <source src="/owlbert.mp3" type="audio/mpeg"/>
    </audio>
    
    <v-btn elevation="2" icon v-on:click="togglePlay()">
      <v-icon v-if="playing$.value">mdi-pause</v-icon>
      <v-icon v-else>mdi-play</v-icon>
    </v-btn>
    </div>
</template>

<script>
import { timer, from, BehaviorSubject, EMPTY } from "rxjs";
import { concatMap, tap, switchMap, finalize, skip } from "rxjs/operators";
export default {
  name: "CallingPlayer",

  props: ['data'],

  data: () => ({
    playing$: new BehaviorSubject(false),
  }),

  created() {
    this.playing$.pipe(
      skip(1),
      tap(() => this.$refs['player'].load()),
      switchMap(p => {
        if (!p) return EMPTY
        else return from(this.data).pipe(
          concatMap(x => {
            if (x.type === 'sound') {
              this.$refs['player'].play()
            }
            return timer(Math.abs(x.duration))
          }),
          tap(() => this.$refs['player'].load()),
          finalize(() => this.playing$.next(false))
        )
      }),
    ).subscribe()
  },

  methods: {
    togglePlay() {
      this.playing$.next(!this.playing$.value)
    },
  },


};
</script>


<style scoped>
.player {
  display: none;
}
</style>