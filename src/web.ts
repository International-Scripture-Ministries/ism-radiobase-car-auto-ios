import { WebPlugin } from '@capacitor/core';

import type { CarplayCapacitorPlugin } from './definitions';

export class CarplayCapacitorWeb
  extends WebPlugin
  implements CarplayCapacitorPlugin
{
  async startStreamingCarPlay(options: { value: string; }): Promise<{ value: string; }> {
    console.log('startStreamingCarPlay', options);
    return options;
  }
  async playStreamingCarPlay(options: { value: string; }): Promise<{ value: string; }> {
    console.log('playStreamingCarPlay', options);
    return options;
  }
  async pauseStreamingCarPlay(options: { value: string; }): Promise<{ value: string; }> {
    console.log('pauseStreamingCarPlay', options);
    return options;
  }
  async isCarplayConnected(options: { value: string; }): Promise<{ value: string; }> {
    console.log('isCarplayConnected', options);
    return options;
  }

  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async play(options: { url: string; title: String; artist: String; image: String }): Promise<{ url: string; title: String; artist: String; image: String }> {
    console.log('play', options);
    return options;
  }

  async pause(options: { value: string }): Promise<{ value: string }> {
    console.log('pause', options);
    return options;
  }

  async getCurrentPlayerItemSeekTime(options: { value: string }): Promise<{ value: string }> {
    console.log('getCurrentPlayerItemSeekTime', options);
    return options;
  }

  async stop(options: { value: string }): Promise<{ value: string }> {
    console.log('stop', options);
    return options;
  }

  async seekTo(options: { interval: string }): Promise<{ interval: string }> {
    console.log('seekTo', options);
    return options;
  }

  async setVolume(options: { volume: string }): Promise<{ volume: string }> {
    console.log('setVolume', options);
    return options;
  }

  async setRate(options: { rate: string }): Promise<{ rate: string }> {
    console.log('setRate', options);
    return options;
  }

  async getCurrentPlayerState(options: { value: string }): Promise<{ value: string }> {
    console.log('getCurrentPlayerState', options);
    return options;
  }
}
