#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(CarplayCapacitorPlugin, "CarplayCapacitor",
           CAP_PLUGIN_METHOD(startStreamingCarPlay, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(playStreamingCarPlay, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(pauseStreamingCarPlay, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isCarplayConnected, CAPPluginReturnPromise);
)
