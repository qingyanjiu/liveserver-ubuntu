// 实现与MySQL交互
var db = require('./Database');
var liveSqlMapping = require('./LiveSqlMapping');


module.exports = {

    

    //开启推流时，修改直播间状态码为9(正在直播
    updateLiveStatus: function (param, callback) {
        db.pool.getConnection(function (err, connection) {
            var myDate = new Date();
            if (err) {
                console.error(myDate.toLocaleString() + "---" + err);
                return;
            }
            // 建立连接，向表中插入值
            connection.query(liveSqlMapping.end,
                [
                    param.queryStatus,
                    param.desitinyStatus,
                    param.streamCode,
                ], function (err, result) {
                    if (err) {
                        console.error(myDate.toLocaleString() + "---" + err);
                        callback(err, {});
                    }
                    // 释放连接
                    connection.release();
                    callback(err, result);
                });
        });
    },
    

};