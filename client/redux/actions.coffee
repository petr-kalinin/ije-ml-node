import callApi, {callApiWithBody} from '../lib/callApi'

import {getRawData} from './getters'

export GET_DATA = 'GET_DATA'
export INVALIDATE_DATA = 'INVALIDATE_DATA'
export INVALIDATE_ALL_DATA = 'INVALIDATE_ALL_DATA'
export SAVE_DATA_PROMISES = 'SAVE_DATA_PROMISES'
export LOGOUT = 'LOGOUT'
export LOGIN = 'POST_LOGIN'

export updateData = (url, minAgeToUpdate, cookies) ->
    (dispatch, getState) ->
        existingData = getRawData(getState(), url)
        existingDataTime = existingData?.updateTime
        if existingDataTime
            if not minAgeToUpdate?
                return
            # -200 to ensure that on age equal to minAgeToUpdate we re-request data
            if (new Date() - existingDataTime) < minAgeToUpdate - 200
                return
        dispatch
            type: GET_DATA
            payload: callApiWithBody url, 'GET', if cookies then {"Cookie": cookies} else {}
            meta:
                url: url

export invalidateData = (url) ->
    return
        type: INVALIDATE_DATA
        meta:
            url: url

export saveDataPromises = (promises) ->
    return
        type: SAVE_DATA_PROMISES
        payload:
            dataPromises: promises

export invalidateAllData = () ->
    return
        type: INVALIDATE_ALL_DATA

export logout = () ->
    (dispatch) ->
        await callApi 'logout'
        dispatch(invalidateAllData())
