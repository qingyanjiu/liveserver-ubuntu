var rf = require("fs");
var dbip = rf.readFileSync("conf/DBIp","utf-8");

var constants = {
    DB_ALIA: dbip,

    LIVE_STATUS_STARTED: "0",
    LIVE_STATUS_ENDED: "1",
    LIVE_STATUS_LIVING: "9",
};

module.exports = constants;