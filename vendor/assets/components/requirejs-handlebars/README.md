# requirejs-handlebars

Simple Handlebars plugin for RequireJS.

* Requires the official `text!` plugin.
* Like the offical `text!` plugin, include the file extension in the module id.
* Make sure to [include the runtime build](#handlebars-runtime) of Handlebars in your build.

## Example usage

    define(['hb!myTemplate.tpl'], function(myTemplate) {

        var html = myTemplate({name:'John Doe'});

    });

## Partials

This plugin has no automatic partial registration (by design).

    define(['hb!myTemplate.tpl', 'hb!myPartial.tpl'], function(myTemplate, myPartial) {

        var html = myTemplate({name:'John Doe'}, {
            partials: {
                myPartial: myPartial
            }
        });

    });

## Example config

    require.config({
        paths: {
            text: 'lib/requirejs-text/text',
            handlebars: 'lib/handlebars/handlebars',
            hb: 'lib/requirejs-handlebars/hb'
        },
        shim: {
            handlebars: {
                exports: 'Handlebars'
            }
        }
    });

## Handlebars runtime

The Handlebars runtime is much smaller than the full version, and it's made to render pre-compiled templates.
It's highly efficient to use pre-compiled templates and the runtime template engine in production.
There are a couple of ways to do this, but probably the easiest is to overrule the path in the r.js build config, e.g.:

        paths: {
            handlebars: 'lib/handlebars/handlebars.runtime',
        }

Additionally, install Handlebars with npm, so the plugin still has the full version available during build:

    npm install handlebars --save-dev
