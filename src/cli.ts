(() => {
  const config = require('./config');
  const yargs = require('yargs/yargs');

  yargs(process.argv.slice(2))
  .commandDir('commands', {recurse: true, extensions: ["js"]})
  .config(config)
  .demandCommand()
  .help()
  .wrap(null)
  .argv

})();
