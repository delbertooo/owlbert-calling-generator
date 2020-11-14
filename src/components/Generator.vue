<template>
  <v-container>
    <v-row class="text-center">
      <v-col class="mb-4" cols="12">
        <h1 class="display-2 font-weight-bold">
          Hit <span class="keybind">SPACE</span> to conduct callings.
        </h1>
      </v-col>

      <v-col class="mb-5" cols="12">
        <audio controls ref="player" class="player" loop>
          <source src="/owlbert.ogg" type="audio/ogg; codecs=vorbis"/>
          <source src="/owlbert.mp3" type="audio/mpeg"/>
        </audio>
        callings here plz!
        <div>
          <span class="mx-2" v-for="(d, index) in preview" :key="index">{{d.duration}}</span>
        </div>
        callings
        <div v-for="(c, index) in callings" :key="index">
          <span class="mx-2" v-for="(d, index) in c" :key="index">{{d.duration}}</span>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { fromEvent, merge } from "rxjs";
import { map, withLatestFrom, filter, tap, debounceTime, buffer } from "rxjs/operators";

function timestamp() {
  return new Date().getTime();
}

function toDuration() {
  return map(([s, e]) => ({ duration: e.end - s.start }));
}

function noRepeat() {
  return filter(x => x && x.repeat == false)
}

const STOP_CONDUCTING_AFTER_MS = 4000

export default {
  name: "Generator",

  created() {
    const keyDown$ = fromEvent(document, "keydown")
    const keyUp$ = fromEvent(document, "keyup")

    //merge(keyDown$, keyUp$).subscribe(e => console.log(e))

    const starts$ = keyDown$.pipe(noRepeat(), map(() => ({ start: timestamp() })))
    const ends$ = keyUp$.pipe(noRepeat(), map(() => ({ end: timestamp() })))
    
    //merge(starts$, ends$).subscribe(e => console.log(e))

    const sound$ = ends$.pipe(
      withLatestFrom(starts$),
      map(([e, s]) => [s, e]),
      toDuration(),
      map((d) => ({ ...d, type: "sound" })),
    )

    const pause$ = starts$.pipe(
      withLatestFrom(ends$),
      toDuration(),
      map((d) => ({ ...d, type: "pause" })),
    )

    const instructions$ = merge(sound$, pause$)

    const longTimeNoSound$ = instructions$.pipe(
      debounceTime(STOP_CONDUCTING_AFTER_MS),
      //tap(e => console.log('done?', e)),
      filter(e => e.type == 'sound'),
      //tap(e => console.log('done!', e)),
    )

    instructions$.pipe(
      filter(x => !(this.preview.length === 0 && x.type == 'pause')), // ugly :(
      tap(x => this.preview = [...this.preview, x]),
      buffer(longTimeNoSound$),
      tap(() => this.preview = []),
      tap(x => console.log('calling', x)),
    ).subscribe(c => this.callings = [c, ...this.callings])

    starts$.subscribe(() => this.$refs['player'].play())
    ends$.subscribe(() => {
      this.$refs['player'].pause()
      this.$refs['player'].load()
    })
  },

  data: () => ({
    preview: [],
    callings: [],
  }),
};
</script>

<style>
.keybind {
  background: #d9d9d9;
  font-size: 80%;
  font-family: monospace;
  vertical-align: bottom;
}
.keybind::before {
  content: "[";
}
.keybind::after {
  content: "]";
}
.player {
  display: none;
}
</style>