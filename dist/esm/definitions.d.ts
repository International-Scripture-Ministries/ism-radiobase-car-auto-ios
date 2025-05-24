export interface CarplayCapacitorPlugin {
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
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
    play(options: {
        url: string;
        title: String;
        artist: String;
        image: String;
    }): Promise<{
        url: string;
        title: String;
        artist: String;
        image: String;
    }>;
    pause(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    getCurrentPlayerItemSeekTime(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    stop(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    seekTo(options: {
        interval: string;
    }): Promise<{
        interval: string;
    }>;
    setVolume(options: {
        volume: string;
    }): Promise<{
        volume: string;
    }>;
    setRate(options: {
        rate: string;
    }): Promise<{
        rate: string;
    }>;
    getCurrentPlayerState(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
}
