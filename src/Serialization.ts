
exports.toJson = function toJson(object: any, indent: number = 4) {
    return JSON.stringify(object, exports.replacer, indent);
}

exports.replacer = function replacer(key: string, value: any) {
    if (value instanceof Map) {
        return {
            dataType: 'Map',
            value: Array.from(value.entries()), // or with spread: value: [...value]
        };
    } else {
        return value;
    }
}

exports.reviver = function reviver(key: string, value: any) {
    if (typeof value === 'object' && value !== null) {
        if (value.dataType === 'Map') {
            return new Map(value.value);
        }
    }
    return value;
}

exports.mapEnv = function mapEnv(input: Array<string>) {
    if (!input)
        throw new Error("input is falsy");
    const object: any = {};
    input.forEach((v: string, index: number, array: Array<string>) => {
        const split = v.split('=');
        object[split[0]] = split[1];
    });
    return object;
}