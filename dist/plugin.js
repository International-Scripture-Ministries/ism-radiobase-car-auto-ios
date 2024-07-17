var capacitorCarplayCapacitor = (function (exports, core) {
    'use strict';

    const CarplayCapacitor = core.registerPlugin('CarplayCapacitor', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.CarplayCapacitorWeb()),
    });

    class CarplayCapacitorWeb extends core.WebPlugin {
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
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        CarplayCapacitorWeb: CarplayCapacitorWeb
    });

    exports.CarplayCapacitor = CarplayCapacitor;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
