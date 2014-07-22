gulp       = require 'gulp'
browserify = require 'gulp-browserify'
rename     = require 'gulp-rename'
sass       = require 'gulp-ruby-sass'
plumber    = require 'gulp-plumber'

gulp.task 'scss', ->
    gulp.src 'scss/star.scss'
        .pipe plumber()
        .pipe sass()
        .pipe gulp.dest('./static/')

gulp.task 'coffee', ->
    gulp.src 'coffee/star.coffee', read: false
        .pipe plumber()
        .pipe browserify
            transform: ['coffeeify']
            extensions: ['*.coffee']
        .pipe rename 'star.js'
        .pipe gulp.dest('./static')

gulp.task 'watch', ->
    gulp.watch 'coffee/**/*.coffee', ['coffee']
    gulp.watch 'scss/**/*.scss', ['scss']

gulp.task 'default', ['scss', 'coffee', 'watch']
