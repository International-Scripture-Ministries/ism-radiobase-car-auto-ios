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
}
