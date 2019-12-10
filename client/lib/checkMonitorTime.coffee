DAY = 24 * 60 * 60 * 1000

export default checkMonitorTime = (contestData) ->
    curTime = ((new Date()) % DAY) / 1000
    monitorTime = (contestData.start + contestData.time + contestData.dst * 60) * 60
    return Math.abs(curTime - monitorTime) <= 2 * 60