import { registerPlugin } from '@capacitor/core';
const CarplayCapacitor = registerPlugin('CarplayCapacitor', {
    web: () => import('./web').then(m => new m.CarplayCapacitorWeb()),
});
export * from './definitions';
export { CarplayCapacitor };
//# sourceMappingURL=index.js.map