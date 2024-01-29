export interface CarplayCapacitorPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
