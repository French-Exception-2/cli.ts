interface InitArgv {

}

(async () => {
  exports.command = 'init';
  exports.desc = 'Init';
  exports.builder = ((processCwd) => {

  })(process.cwd());
  exports.handler = async function (argv: InitArgv) {
    
  };
})();
