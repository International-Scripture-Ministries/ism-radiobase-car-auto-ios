export interface CarplayCapacitorPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  startStreamingCarPlay(options: { value: string }): Promise<{ value: string }>;
  playStreamingCarPlay(options: { value: string }): Promise<{ value: string }>;
  pauseStreamingCarPlay(options: { value: string }): Promise<{ value: string }>;
  isCarplayConnected(options: { value: string }): Promise<{ value: string }>;
}
