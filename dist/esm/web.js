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
    async play(options) {
        console.log('play', options);
        return options;
    }
    async pause(options) {
        console.log('pause', options);
        return options;
    }
    async getCurrentPlayerItemSeekTime(options) {
        console.log('getCurrentPlayerItemSeekTime', options);
        return options;
    }
    async stop(options) {
        console.log('stop', options);
        return options;
    }
    async seekTo(options) {
        console.log('seekTo', options);
        return options;
    }
    async setVolume(options) {
        console.log('setVolume', options);
        return options;
    }
    async setRate(options) {
        console.log('setRate', options);
        return options;
    }
    async getCurrentPlayerState(options) {
        console.log('getCurrentPlayerState', options);
        return options;
    }
}
//# sourceMappingURL=web.js.map