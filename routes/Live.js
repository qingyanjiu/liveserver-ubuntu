'use strict';

var httpReq = require('../services/HttpRequests');
var Date = require('../services/MyDate');
var exec = require('child_process').exec;

var express = require('express');
var router = express.Router();
var liveBusiness = require('../business/LiveBusiness');
var constants = require('../services/constants');


//开播
router.get('/onpublish', function (req, res, next) {
    var streamCode = req.query.name;
    var param = {};
    param.streamCode = streamCode;
    liveBusiness.onpublish(param, (err, data) = > {
        if (err) {
            console.error("LiveRouter--post--end--error");
            console.error(err);
            res.json({"error": "开播失败,请稍后再试"});
            // throw err;
        }
        if (data) {
            if (data.result === "success")
                res.writeHead(200, {"Content-Type": "text/html;charset=utf-8"});
            res.end();
        }
    }
    )
    ;
});

//停播
router.get('/endpublish', function (req, res, next) {
    var streamCode = req.query.name;
    var param = {};
    param.streamCode = streamCode;
    liveBusiness.endpublish(param, (err, data) = > {
        if (err) {
            console.error("LiveRouter--post--end--error");
            console.error(err);
            res.json({"error": "停播失败,请稍后再试"});
            // throw err;
        }
        if (data) {
            if (data.result === "success")
                res.writeHead(200, {"Content-Type": "text/html;charset=utf-8"});
            res.end();
        }
    }
    )
    ;
});


//停止录制,上传录制的文件到oss
router.get('/endrecord', function (req, res, next) {
    var myDate = new Date();
    var date = myDate.pattern("yyyy-MM-dd-HH:mm:ss");
    var streamCode = req.query.name;
    var recorder = req.query.recorder;
    var path = req.query.path
    var co = require('co');
    var OSS = require('ali-oss')

    //给录制的视频加关键帧，保存在record目录
    var cmdStr = "yamdi -i " + path +
        " -o " + path.substring(0, path.lastIndexOf("/")) +
        "record_" + streamCode + ".flv";

    exec(cmdStr, function (err, stdout, stderr) {
        if (err) {
            console.log('添加关键帧出错' + stderr);
        } else {
            console.log('添加关键帧成功');
            //添加完关键帧后，开始将添加关键帧后的视频上传到oss，截图用的视频不上传
            if (recorder != "preview") {
                var client = new OSS({
                    region: 'oss-cn-shanghai',
                    accessKeyId: 'QkCwVzn2G3St9HDo',
                    accessKeySecret: 'hsM9Sh3bTNId6ZCbea02FFXHMHygYN',
                    bucket: 'mokulive'
                });
                co(function*() {
                    var result = yield client.put('/videos/' + streamCode + "-" + date + ".flv", path.substring(0, path.lastIndexOf("/")) +
                        "record_" + streamCode + ".flv");
                    console.log(result);
                }).catch(function (err) {
                    console.log(err);
                });
            }
        }
    });


});


module.exports = router;
