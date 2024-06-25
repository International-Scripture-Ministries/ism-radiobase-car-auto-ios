import { WebPlugin } from '@capacitor/core';
export class CarplayCapacitorWeb extends WebPlugin {
    async startStreamingCarPlay(options) {
        console.log('startStreamingCarPlay', options);
        return options;
    }
    async playStreamingCarPlay(options) {
        console.log('playStreamingCarPlay', options);
        return options;
    }
    async pauseStreamingCarPlay(options) {
        console.log('pauseStreamingCarPlay', options);
        return options;
    }
    async isCarplayConnected(options) {
        console.log('isCarplayConnected', options);
        return options;
    }
    async echo(options) {
        console.log('ECHO', options);
        return options;
    }
}
//# sourceMappingURL=web.js.map