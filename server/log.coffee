log4js = require('log4js')
log4js.configure({
  appenders: {
    out: { type: 'stdout' },
    app: { type: 'file', filename: 'ije_ml_node.log' }
  },
  categories: {
    default: { appenders: [ 'out', 'app' ], level: 'info' }
  }
});

logger = log4js.getLogger()
logger.level = 'info'

export default logger
