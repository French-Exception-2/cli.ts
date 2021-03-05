(() => {

    {{ codeBefore | code }}

    exports.command = {{ command | quote }}
    exports.desc = {{ desc | quote }}
    exports.builder = {{ builder | json }}
    exports.handler = function (argv: any) {
        {{ handler | code }}
    }

})();