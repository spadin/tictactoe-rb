/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: '<json:package.json>',
    meta: {
      banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
        '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
        '<%= pkg.homepage ? "* " + pkg.homepage + "\n" : "" %>' +
        '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
        ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */'
    },
    lint: {
      files: ['grunt.js', 'test/**/*.js']
    },
    coffee: {
      compile: {
        files: {
          'lib/<%= pkg.name %>.js': [
            'lib/helpers/namespace.coffee', 
            'lib/models/*.coffee', 
            'lib/models/**/*.coffee', 
            'lib/views/*.coffee'
          ],
          'workers/tictactoe-ai-worker.js': [
            'workers/tictactoe-ai-worker.coffee'
          ]
        }
      }
    },
    jst: {
      compile: {
        options: {
          prettify: true,
          namespace: 'tttTemplates',
          processName: function(filename) {
            filename = filename.replace("lib/templates/","");
            filename = filename.replace(".jst","");
            return filename;
          }
        },
        files: {
          "lib/templates.js": ["lib/templates/**/*.jst"]
        }
      }
    },
    qunit: {
      files: ['test/**/*.html']
    },
    concat: {
      dist: {
        src: [
          '<banner:meta.banner>', 
          'lib/vendor.js',
          'lib/templates.js',
          '<file_strip_banner:lib/<%= pkg.name %>.js>'
        ],
        dest: 'dist/<%= pkg.name %>.js'
      },
      vendor: {
        src: [
          'vendor/jquery-1.8.3.min.js',
          'vendor/underscore-min.js',
          'vendor/backbone-min.js'
        ],
        dest: 'lib/vendor.js'
      },
      worker: {
        src: [
          'vendor/underscore-min.js',
          'workers/tictactoe-ai-worker.js'
        ],
        dest: 'lib/tictactoe-worker.js'
      }
    },
    min: {
      dist: {
        src: ['<banner:meta.banner>', '<config:concat.dist.dest>'],
        dest: 'dist/<%= pkg.name %>.min.js'
      }
    },
    watch: {
      files: ['<config:lint.files>', 'lib/**/*.coffee', 'workers/**/*.coffee', 'lib/**/*.jst'],
      tasks: 'coffee jst lint qunit concat:vendor concat:worker'
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        boss: true,
        eqnull: true,
        browser: true
      },
      globals: {}
    },
    uglify: {}
  });

  // Default task.
  grunt.registerTask('default', 'coffee jst lint qunit concat:dist min');

  // Load tasks
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-jst');

};
