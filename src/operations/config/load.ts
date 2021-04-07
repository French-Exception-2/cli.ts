async function load(givenPath: string) {
    const api = require('@frenchex/config-api');
    const path = require('path');

    const config = await api.fromFile({
        env: { env: 'dev' },
        file: path.join(givenPath, 'config.json'),
        root: givenPath
    });

    return config;
}

module.exports.load = load