import { WebPlugin } from '@capacitor/core';
import type { CarplayCapacitorPlugin } from './definitions';
export declare class CarplayCapacitorWeb extends WebPlugin implements CarplayCapacitorPlugin {
    startStreamingCarPlay(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    playStreamingCarPlay(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    pauseStreamingCarPlay(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    isCarplayConnected(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
}
