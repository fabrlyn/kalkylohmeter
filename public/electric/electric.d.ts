/* tslint:disable */
/* eslint-disable */
/**
* @param {number} amps
* @param {number} ohm
* @returns {number}
*/
export function volts(amps: number, ohm: number): number;
/**
* @param {number} volts
* @param {number} ohm
* @returns {number}
*/
export function amps(volts: number, ohm: number): number;
/**
* @param {number} volts
* @param {number} amps
* @returns {number}
*/
export function ohm(volts: number, amps: number): number;

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly volts: (a: number, b: number) => number;
  readonly amps: (a: number, b: number) => number;
  readonly ohm: (a: number, b: number) => number;
}

/**
* If `module_or_path` is {RequestInfo} or {URL}, makes a request and
* for everything else, calls `WebAssembly.instantiate` directly.
*
* @param {InitInput | Promise<InitInput>} module_or_path
*
* @returns {Promise<InitOutput>}
*/
export default function init (module_or_path?: InitInput | Promise<InitInput>): Promise<InitOutput>;
