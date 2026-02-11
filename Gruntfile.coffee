# THIS IS NOW DEPRECATED BUT POSSIBILITY IS TO USE GRUNT AGAIN.
module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    # Clean the dist directory before build
    clean:
      dist: ['dist']

    # Use Esbuild
    # --splitting: Enables code splitting for dynamic import
    # --outdir: Required for splitting
    # --sourcemap: Generates .map files for debugging
    exec:
      build:
        cmd: 'npx esbuild index.tsx --bundle --outdir=dist --splitting --format=esm --external:react --external:react-dom --jsx=automatic --target=esnext --sourcemap'

    # Development server
    connect:
      server:
        options:
          port: 3000
          base: '.'
          livereload: true
          open: true
          # SPA Fallback: Redirect 404s to index.html so routing works on refresh
          middleware: (connect, options, middlewares) ->
            middlewares.unshift (req, res, next) ->
              # Only redirect if not asking for a file with an extension (like .js, .css, .json)
              if req.url.indexOf('.') == -1
                req.url = '/index.html'
              next()
            return middlewares

    # Watch files for changes
    watch:
      scripts:
        files: ['**/*.tsx', '**/*.ts', '**/*.json', 'index.html']
        tasks: ['exec:build']
        options:
          livereload: true
          spawn: false

  # Load Grunt plugins
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-exec'

  # Register tasks
  grunt.registerTask 'default', ['clean', 'exec:build', 'connect', 'watch']
  grunt.registerTask 'build', ['clean', 'exec:build']
