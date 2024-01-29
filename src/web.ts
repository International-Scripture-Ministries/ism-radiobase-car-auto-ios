import { WebPlugin } from '@capacitor/core';

import type { CarplayCapacitorPlugin } from './definitions';

export class CarplayCapacitorWeb
  extends WebPlugin
  implements CarplayCapacitorPlugin
{
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
