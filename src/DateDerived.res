let day_of_ms = 1000 * 60 * 60 * 24

let getMonthForWeekOfYear = (weekNumber, year) => {
  let firstDayOfYear = Date.makeWithYMD(~year, ~month=0, ~date=1)

  let dayOfWeek = firstDayOfYear->Date.getDay
  let firstMondayOfYear = firstDayOfYear

  if dayOfWeek != 1 {
    let offset = dayOfWeek == 0 ? 1 : 8 - dayOfWeek
    firstMondayOfYear->Date.setDate(firstDayOfYear->Date.getDate + offset)
  }

  let dateOfWeek = firstMondayOfYear->Date.getTime->Date.fromTime
  dateOfWeek->Date.setDate(firstMondayOfYear->Date.getDate + (weekNumber - 1) * 7)

  dateOfWeek->Date.getMonth + 1
}

let getDaysOfWeek = (week, year) => {
  let firstDayOfYear = Date.makeWithYMD(~year, ~month=0, ~date=1)

  let daysOffset = (week - 1) * 7
  let dayOfWeek = firstDayOfYear->Date.getDay

  let offsetToMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1
  let mondayOfWeek = Date.makeWithYMD(~year, ~month=0, ~date=1 + daysOffset - offsetToMonday)

  Array.make(~length=7, false)->Array.mapWithIndex((_, i) => {
    let day = mondayOfWeek->Date.getTime->Date.fromTime
    day->Date.setDate(mondayOfWeek->Date.getDate + i)
    day
  })
}

let allDays = (start, end) => {
  let inc = start->Date.getTime->Date.fromTime

  let dayDiff =
    Math.floor((end->Date.getTime -. inc->Date.getTime) /. day_of_ms->Int.toFloat)->Float.toInt
  Array.make(~length=dayDiff, false)->Array.mapWithIndex((_, _i) => {
    let result = inc->Date.getTime->Date.fromTime
    inc->Date.setDate(inc->Date.getDate + 1)
    result
  })
}

let allYears = (start, end) => {
  let startYear = start->Date.getFullYear
  let endYear = end->Date.getFullYear

  Array.make(~length=endYear - startYear, false)->Array.mapWithIndex((_, i) => {
    Date.makeWithYMD(~year=startYear + i, ~month=0, ~date=1)
  })
}

let ymdDate = (year, month, date) => Date.makeWithYMD(~year, ~month, ~date)
