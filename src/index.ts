import { registerPlugin } from '@capacitor/core';

import type { CarplayCapacitorPlugin } from './definitions';

const CarplayCapacitor = registerPlugin<CarplayCapacitorPlugin>(
  'CarplayCapacitor',
  {
    web: () => import('./web').then(m => new m.CarplayCapacitorWeb()),
  },
);

export * from './definitions';
export { CarplayCapacitor };
