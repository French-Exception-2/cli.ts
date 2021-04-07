#!/usr/bin/env ts-node

const chokidar = require('chokidar');

const watcher = chokidar.watch(['src', 'test'], {
    ignored: null,
    ignoreInitial: false,
    followSymlinks: true,
    cwd: '.',
    disableGlobbing: false,

    usePolling: false,
    interval: 100,
    binaryInterval: 300,
    alwaysStat: false,
    depth: null,
    awaitWriteFinish: {
        stabilityThreshold: 2000,
        pollInterval: 100
    },

    ignorePermissionErrors: false,
    atomic: true
});

process.on('SIGINT', async () => {
    await watcher.close();
    if (proc) proc.kill();
    console.log('watcher closed');
});

const fs = require('fs-extra');
const _path = require('path');
const glob = require('glob');
const keypress = require('keypress');
keypress(process.stdin);
const rimraf = require('rimraf');

// Something to use when events are received.
const log = console.log.bind(console);

const spawn = require('child_process').spawn

const isWindows = /^win/.test(process.platform);

var proc:any;

proc = spawn(isWindows ? 'npx.cmd':'npx', ['tsc', '--watch'], {stdio:'inherit'})

watcher
    .on('ready', async () => {
        log('Initial scan complete. Ready for changes');
        log('Executing "npx tsc --watch" build process');

        process.stdin.on('keypress',async function (ch, key) {
            console.log('got "keypress"', key);

            if (key && key.ctrl && key.name == 'c') {
                proc.kill();
                await watcher.close();
                process.exit();
            }

            if (key && key.name == 'd') {
                console.log('destroying build');
                proc.kill();
                rimraf('build', {}, () => {
                    proc = spawn(isWindows ? 'npx.cmd':'npx', ['tsc'], {stdio:'inherit'})
                });
            }
          });
           
          process.stdin.setRawMode(true);
          process.stdin.resume();

        watcher
            .on('unlink', async (path: string) => {
                log(`File ${path} has been removed`)
                const ext = _path.extname(path);
                const file = _path.basename(path, ext);
                const dir = _path.dirname(path);

                const pattern = _path.join(process.cwd(), 'build', dir, file + '.*');

                glob(pattern, {}, (er:any, files:Array<string>) => {
                    files.forEach(async (file:string) => {
                        await fs.unlink(file);
                        console.log(file);
                    })
                })
                
            });
    })
    ;