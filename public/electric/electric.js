
let wasm;

/**
* @param {number} amps
* @param {number} ohm
* @returns {number}
*/
export function volts(amps, ohm) {
    var ret = wasm.volts(amps, ohm);
    return ret;
}

/**
* @param {number} volts
* @param {number} ohm
* @returns {number}
*/
export function amps(volts, ohm) {
    var ret = wasm.amps(volts, ohm);
    return ret;
}

/**
* @param {number} volts
* @param {number} amps
* @returns {number}
*/
export function ohm(volts, amps) {
    var ret = wasm.amps(volts, amps);
    return ret;
}

async function load(module, imports) {
    if (typeof Response === 'function' && module instanceof Response) {
        if (typeof WebAssembly.instantiateStreaming === 'function') {
            try {
                return await WebAssembly.instantiateStreaming(module, imports);

            } catch (e) {
                if (module.headers.get('Content-Type') != 'application/wasm') {
                    console.warn("`WebAssembly.instantiateStreaming` failed because your server does not serve wasm with `application/wasm` MIME type. Falling back to `WebAssembly.instantiate` which is slower. Original error:\n", e);

                } else {
                    throw e;
                }
            }
        }

        const bytes = await module.arrayBuffer();
        return await WebAssembly.instantiate(bytes, imports);

    } else {
        const instance = await WebAssembly.instantiate(module, imports);

        if (instance instanceof WebAssembly.Instance) {
            return { instance, module };

        } else {
            return instance;
        }
    }
}

async function init(input) {
    if (typeof input === 'undefined') {
        input = new URL('electric_bg.wasm', import.meta.url);
    }
    const imports = {};


    if (typeof input === 'string' || (typeof Request === 'function' && input instanceof Request) || (typeof URL === 'function' && input instanceof URL)) {
        input = fetch(input);
    }



    const { instance, module } = await load(await input, imports);

    wasm = instance.exports;
    init.__wbindgen_wasm_module = module;

    return wasm;
}

export default init;

