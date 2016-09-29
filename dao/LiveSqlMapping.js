var liveSqlMapping = {
  updateLiveStatus:'update live_info set status=? where streamcode=? and status=?',
};

module.exports = liveSqlMapping;