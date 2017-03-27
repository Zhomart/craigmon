Mixin = {
  // init method is a special one which can initialize
  // the mixin when it's loaded to the tag and is not
  // accessible from the tag its mixed in
  init: function() {
  },

  mixinFixItem: function(_item){
    item = this.helperFixRecordDates(_item, ["date", "issued", "vanished_at"])
    item.title = item.title.replace(/&#x0024;.+$/, "").trim()
    item.vanished_in = this.mixinVanishedInCalc(item.vanished_at, item.date, item.created_at)
    return item
  },

  helperFixRecordDates: function(record, propreties = []) {
    if (-1 == propreties.indexOf("created_at")) propreties.push("created_at")
    if (-1 == propreties.indexOf("updated_at")) propreties.push("updated_at")
    var rec = Object.assign({}, record)
    for (var i in propreties) {
      var prop = propreties[i];
      rec[prop] = rec[prop] ? new Date(rec[prop]) : null
    }
    return rec;
  },

  mixinVanishedInCalc: function(vanished_at, date, created_at) {
    if (!vanished_at)
      return "";

    let initial_date = date < created_at ? date : created_at;
    var diff = (vanished_at - initial_date) / 60000;
    var measure = "mins";
    if (diff > 90) {
      diff = diff / 60;
      measure = "hours";
    }
    if (diff > 48) {
      diff = diff / 24;
      measure = "days";
    }
    diff = Math.round(diff * 10) / 10;

    return `in ${diff} ${measure}`;
  },

}
