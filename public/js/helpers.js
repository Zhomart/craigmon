function helperFixRecordDates(record, propreties = []) {
  if (-1 == propreties.indexOf("created_at")) propreties.push("created_at")
  if (-1 == propreties.indexOf("updated_at")) propreties.push("updated_at")
  var rec = Object.assign({}, record)
  for (var i in propreties) {
    var prop = propreties[i];
    rec[prop] = rec[prop] ? new Date(rec[prop]) : null
  }
  return rec;
}
