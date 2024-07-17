export interface CarplayCapacitorPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  startStreamingCarPlay(options: { value: string }): Promise<{ value: string }>;
  playStreamingCarPlay(options: { value: string }): Promise<{ value: string }>;
  pauseStreamingCarPlay(options: { value: string }): Promise<{ value: string }>;
  isCarplayConnected(options: { value: string }): Promise<{ value: string }>;
  play(options: { url: string; title: String; artist: String; image: String }): Promise<{ url: string; title: String; artist: String; image: String }>;
  pause(options: { value: string }): Promise<{ value: string }>;  
  getCurrentPlayerItemSeekTime(options: { value: string }): Promise<{ value: string }>;  
}
