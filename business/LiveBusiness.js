'use strict';

var LiveDao = require('../dao/LiveDao');
var guid = require('../services/guid');
var Date = require('../services/MyDate');
var md5 = require('md5');
var constants = require('../services/constants');

var myDate = new Date();
var dateTime = myDate.pattern("yyyy-MM-dd HH:mm:ss");

module.exports = {
    //进入直播状态
    onpublish: function (param, callback) {
        //要匹配的直播间状态(开启中但未直播-0)
        param.queryStatus = constants.LIVE_STATUS_STARTED;
        //需要改变的目标状态(正在直播-9)
        param.destinyStatus = constants.LIVE_STATUS_LIVING;
        LiveDao.updateLiveStatus(param, function (err, result) {
            if (err) {
                console.error("LiveBusiness--startLive--onpublish--error");
                callback(err, {});
            }
            if (result) {
                LiveDao.addLive(param, function (er, res) {
                    if (er) {
                        console.error("LiveBusiness--onpublish--updateLiveStatus--error");
                        callback(er, {});
                    }
                    if(res) {
                        ret = {"result": param.streamcode};
                        callback(err, ret);
                    }
                });
            }
        });
    },

    //进入停播状态
    endpublish: function (param, callback) {
        //需要匹配的目标状态(正在直播-9)
        param.queryStatus = constants.LIVE_STATUS_LIVING;
        //要改变的直播间状态(开启中但未直播-0)
        param.destinyStatus = constants.LIVE_STATUS_STARTED;
        
        LiveDao.updateLiveStatus(param, function (err, result) {
            if (err) {
                console.error("LiveBusiness--startLive--onpublish--error");
                callback(err, {});
            }
            if (result) {
                LiveDao.addLive(param, function (er, res) {
                    if (er) {
                        console.error("LiveBusiness--onpublish--updateLiveStatus--error");
                        callback(er, {});
                    }
                    if(res) {
                        ret = {"result": param.streamcode};
                        callback(err, ret);
                    }
                });
            }
        });
    },

};