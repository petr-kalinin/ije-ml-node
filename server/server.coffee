require('source-map-support').install()

import csshook from 'css-modules-require-hook/preset'

express = require('express')
compression = require('compression')
session = require('express-session')
MongoStore = require('connect-mongo')(session)
import bodyParser from "body-parser"

import logger from './log'
import renderOnServer from './ssr/renderOnServer'
import db from './mongo/mongo'
import download from './lib/download'
import sleep from './lib/sleep'

import api from './api/setupApi'

process.on 'unhandledRejection', (r) ->
    logger.error "Unhandled rejection "
    logger.error r

requireHTTPS = (req, res, next) ->
    if !req.secure and !req.headers.host.startsWith("127.0.0.1")  # the latter is to avoid inner api requests
        return res.redirect 'https://' + req.headers.host + req.url
    next()

app = express()
app.enable('trust proxy')

if process.env["FORCE_HTTPS"]
    app.use(requireHTTPS)

app.use(compression())

app.use(express.static('build/assets'))

app.use(express.static('public'))

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.raw({type: 'multipart/form-data'}))

app.use (req, res, next) ->
    logger.info "Request #{req.path}"
    next()

app.use session
    cookie:
        maxAge: 10 * 60 * 60 * 1000
    secret: 'foo',
    store: new MongoStore({ url: 'mongodb://localhost/session' })
    resave: false
    saveUninitialized: false

app.use (req, res, next) ->
    if not req.session?.contest
        req.session.contest = 0
    next()

app.use '/api', api

app.get '/status', (req, res) ->
    logger.info "Query string", req.query
    res.send "OK"

app.use renderOnServer

port = (process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || 3000)

start = () ->
    #try
    #    await logger.info("My ip is " + JSON.parse(await download 'https://api.ipify.org/?format=json')["ip"])
    #catch
    #    logger.error("Can not determine my ip")

    app.listen port, () ->
        logger.info 'App listening on port ', port
        await sleep(10 * 1000)  # wait for a bit to make sure previous deployment has been stopped
        logger.info("Starting jobs")
        #jobs.map((job) -> job.start())

start()
