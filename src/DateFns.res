type interval = {
  start: float,
  end: float,
}

type duration = {
  years: int,
  months: int,
  days: int,
  hours: int,
  minutes: int,
  seconds: int,
}

@module("date-fns")
external getTime: Js.Date.t => int = "getTime"

@module("date-fns")
external format: (Js.Date.t, string) => string = "format"

@module("date-fns")
external parse: (string, string, int) => Js.Date.t = "parse"

@module("date-fns")
external parseISO: string => Js.Date.t = "parseISO"

@module("date-fns")
external intervalToDuration: interval => duration = "intervalToDuration"

@module("date-fns")
external min: array<Js.Date.t> => Js.Date.t = "min"

@module("date-fns")
external max: array<Js.Date.t> => Js.Date.t = "max"

@module("date-fns")
external isSameDay: (Js.Date.t, Js.Date.t) => bool = "isSameDay"

@module("date-fns")
external isBefore: (Js.Date.t, Js.Date.t) => bool = "isBefore"

@module("date-fns")
external isAfter: (Js.Date.t, Js.Date.t) => bool = "isAfter"

@module("date-fns")
external isEqual: (Js.Date.t, Js.Date.t) => bool = "isEqual"

@module("date-fns")
external startOfDay: Js.Date.t => Js.Date.t = "startOfDay"

@module("date-fns")
external endOfDay: Js.Date.t => Js.Date.t = "endOfDay"

@module("date-fns")
external startOfWeek: Js.Date.t => Js.Date.t = "startOfWeek"

@module("date-fns")
external startOfMonth: Js.Date.t => Js.Date.t = "startOfMonth"

@module("date-fns")
external startOfQuarter: Js.Date.t => Js.Date.t = "startOfQuarter"

@module("date-fns")
external startOfYear: Js.Date.t => Js.Date.t = "startOfYear"

@module("date-fns")
external getDayOfYear: Js.Date.t => int = "getDayOfYear"

let isAfterOrEqual = (x, y) => isAfter(x, y) || isEqual(x, y)

let isBeforeOrEqual = (x, y) => isBefore(x, y) || isEqual(x, y)
