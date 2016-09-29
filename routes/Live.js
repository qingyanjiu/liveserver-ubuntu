'use strict';

var httpReq = require('../services/HttpRequests');

var express = require('express');
var router = express.Router();
var liveBusiness = require('../business/LiveBusiness');
var constants = require('../services/constants');


//开播
router.post('/onpublish', function (req, res, next) {
    var streamCode = req.query.name;
    var param = {};
    param.streamCode = streamCode;
    liveBusiness.onpublish(param, (err, data)=> {
        if (err) {
            console.error("LiveRouter--post--end--error");
            console.error(err);
            res.json({"error": "开播失败,请稍后再试"});
            // throw err;
        }
        if (data) {
            if (data.result === "success")
                res.json({result: 'success'});
        }
    });
});

//停播
router.post('/endpublish', function (req, res, next) {
    var streamCode = req.query.name;
    var param = {};
    param.streamCode = streamCode;
    liveBusiness.onpublish(param, (err, data)=> {
        if (err) {
            console.error("LiveRouter--post--end--error");
            console.error(err);
            res.json({"error": "停播失败,请稍后再试"});
            // throw err;
        }
        if (data) {
            if (data.result === "success")
                res.json({result: 'success'});
        }
    });
});

module.exports = router;
