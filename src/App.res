@val @scope("document")
external getElementById: string => Js.Nullable.t<Dom.element> = "getElementById"

@val @scope("document")
external getElementsByClassName: string => Js.Nullable.t<array<Dom.element>> =
  "getElementsByClassName"

let getElementByClassOp = s =>
  s
  ->getElementsByClassName
  ->Js.Nullable.toOption
  ->Option.flatMap(x => x->Array.get(0))

let getElementByIdOp = s =>
  s
  ->getElementById
  ->Js.Nullable.toOption

@val @scope("document")
external documentQuerySelector: string => Js.Nullable.t<Dom.element> = "querySelector"

@send
external scrollIntoView: (Dom.element, {"behavior": string, "block": string}) => unit =
  "scrollIntoView"

@send
external focus: Dom.element => unit = "focus"

@set
external selectionStart: (Dom.element, int) => unit = "selectionStart"

@set
external selectionEnd: (Dom.element, int) => unit = "selectionEnd"

@send
external querySelector: (Dom.element, string) => Js.Nullable.t<Dom.element> = "querySelector"

@get @scope("value") external textAreaLength: Dom.element => int = "length"

let intMax = (a, b) => {
  a > b ? a : b
}

module Icons = {
  module Flower = {
    @react.component @module("react-icons/pi")
    external make: (~className: string=?, ~style: JsxDOM.style=?) => React.element = "PiFlowerTulip"
  }
  module Snowflake = {
    @react.component @module("react-icons/tb")
    external make: (~className: string=?, ~style: JsxDOM.style=?) => React.element = "TbSnowflake"
  }
  module Leaf = {
    @react.component @module("react-icons/lu")
    external make: (~className: string=?, ~style: JsxDOM.style=?) => React.element = "LuLeafyGreen"
  }
  module Umbrella = {
    @react.component @module("react-icons/tb")
    external make: (~className: string=?, ~style: JsxDOM.style=?) => React.element = "TbBeach"
  }
  module Lock = {
    @react.component @module("react-icons/tb")
    external make: (~className: string=?, ~style: JsxDOM.style=?) => React.element = "TbLock"
  }
  module OpenLock = {
    @react.component @module("react-icons/tb")
    external make: (~className: string=?, ~style: JsxDOM.style=?) => React.element = "TbLockOpen"
  }
}

type importData = array<(string, string)>

type response

@send external json: response => promise<importData> = "json"

@val
external fetch: string => promise<response> = "fetch"

@module("marked") external parseMd: string => string = "parse"

module Monaco = {
  @react.component @module("./Monaco.jsx")
  external make: (~content: string) => React.element = "default"
}

module TextareaAutosize = {
  @react.component @module("react-textarea-autosize")
  external make: (
    ~value: string,
    ~className: string,
    ~onChange: ReactEvent.Form.t => unit,
    ~readOnly: bool,
  ) => React.element = "default"
}

module TextArea = {
  @react.component
  let make = (~content: string, ~onChange: string => unit, ~className="", ~readonly=false) => {
    <TextareaAutosize
      readOnly={readonly}
      className={["bg-black w-full", className]->Array.join(" ")}
      value={content}
      onChange={e => {
        let value = (e->ReactEvent.Form.target)["value"]
        onChange(value)
      }}
    />
  }
}

module Editor = TextArea

@val external isInvalidDate: Date.t => bool = "isNaN"

@module("./useLocalStorage.js")
external useLocalStorage: (string, 'a) => ('a, ('a => 'a) => unit) = "default"

let concatArray = x => {
  x->Array.reduce([], (a, c) => {
    Array.concat(a, c)
  })
}

type entryDate =
  | Year(int)
  // | Half(int, int)
  | Quarter(int, int)
  | Month(int, int)
  | Week(int, int)
  | Date(int, int, int)

type entry = {
  id: string,
  date: option<entryDate>,
  title: string,
  content: string,
  lock: bool,
}

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

let useStateWithGetter = initial => {
  let (state, setState) = React.useState(initial)
  let stateRef = React.useRef(state)

  React.useEffect1(() => {
    stateRef.current = state
    None
  }, [state])

  let getState = () => stateRef.current

  (state, setState, getState)
}

let format = DateFns.format

let ymdDate = (year, month, date) => Date.makeWithYMD(~year, ~month, ~date)

let entryDateString = date =>
  switch date {
  | Date(y, m, d) => ymdDate(y, m - 1, d)->format("y-MM-dd")
  | Year(y) => y->Int.toString->String.padStart(4, "0")
  // | Half(y, h) => y->Int.toString->String.padStart(4, "0") ++ "-H" ++ h->Int.toString
  | Quarter(y, q) => y->Int.toString->String.padStart(4, "0") ++ "-Q" ++ q->Int.toString
  | Month(y, m) =>
    y->Int.toString->String.padStart(4, "0") ++ "-" ++ m->Int.toString->String.padStart(2, "0")
  | Week(y, w) => y->Int.toString->String.padStart(4, "0") ++ "-W" ++ w->Int.toString
  }

let day_of_ms = 1000 * 60 * 60 * 24

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

let hsv = (h, s, v) => Texel.convert((h, s, v), Texel.okhsv, Texel.srgb)->Texel.rgbToHex
let hsl = (h, s, l) => Texel.convert((h, s, l), Texel.okhsl, Texel.srgb)->Texel.rgbToHex

// let customMonthColor = monthInt => {
//   switch monthInt {
//   | 1 => hsv(260., 1.0, 1.0)
//   | 2 => hsv(0., 1.0, 1.0)
//   | 3 => hsv(140., 1.0, 1.0)
//   | 4 => hsv(100., 1.0, 1.0)
//   | 5 => hsv(100., 1.0, 1.0)
//   | 6 => hsv(100., 1.0, 1.0)
//   | 7 => hsv(100., 1.0, 1.0)
//   | 8 => hsv(100., 1.0, 1.0)
//   | 9 => hsv(90., 1.0, 1.0)
//   | 10 => hsv(50., 1.0, 1.0)
//   | 11 => hsv(50., 1.0, 0.5)
//   | 12 => hsv(150., 1.0, 0.5)
//   | _ => "#000"
//   }
// }

let customMonthHue = (monthInt, _) => {
  switch monthInt {
  | 1 => 210.
  | 2 => 0.
  | 3 => 270.
  | 4 => 120.
  | 5 => 240.
  | 6 => 80.
  | 7 => 40.
  | 8 => 240.
  | 9 => 180.
  | 10 => 60.
  | 11 => 340.
  | 12 => 150.
  | _ => 0.
  }
}

let weekColor = weekInt => {
  let weekPercent = weekInt->Int.toFloat /. 53.
  hsv(weekPercent *. 360., 1.0, 1.0)
}

// let monthHue = monthInt => {
//   let monthPercent = monthInt->Int.toFloat /. 12.

//   mod(monthInt, 2) == 0 ? Float.mod(monthPercent *. 360. +. 180., 360.) : monthPercent *. 360.
// }

// let monthHue = (monthInt, year) => {
//   let phi = 1.618034

//   Float.mod(360. /. phi *. (monthInt + year * 12)->Int.toFloat, 360.0)
// }

let monthHue = monthInt => {
  Float.mod(360. /. 12. *. ((monthInt - 3) * 5)->Int.toFloat, 360.0)
}

let monthColors =
  Array.make(~length=12, false)->Array.mapWithIndex((_, i) => hsl(monthHue(i), 1.0, 0.7))
let monthColorsDim =
  Array.make(~length=12, false)->Array.mapWithIndex((_, i) => hsl(monthHue(i), 1.0, 0.4))

let monthColor = monthInt => {
  monthColors->Array.getUnsafe(monthInt - 1)
}

let monthColorDim = monthInt => {
  monthColorsDim->Array.getUnsafe(monthInt - 1)
}

module Months = {
  @react.component
  let make = (~start, ~end, ~dateSet, ~onClick) => {
    <div className="p-4 bg-black flex-1 overflow-y-scroll flex flex-col gap-2 w-full font-black">
      {allYears(start, end)
      ->Array.map(d => {
        let year = d->Date.getFullYear
        let hasYearEntry = dateSet->Set.has(Year(year)->entryDateString)
        let hasQ1Entry = dateSet->Set.has(Quarter(year, 1)->entryDateString)
        let hasQ2Entry = dateSet->Set.has(Quarter(year, 2)->entryDateString)
        let hasQ3Entry = dateSet->Set.has(Quarter(year, 3)->entryDateString)
        let hasQ4Entry = dateSet->Set.has(Quarter(year, 4)->entryDateString)
        let entryCheck = x => x ? `text-lime-500 bg-black` : "text-inherit bg-black"

        <div
          className="gap-px text-xs bg-plain-800 border border-plain-700 text-plain-600"
          style={{
            display: "grid",
            gridTemplateColumns: "1fr 1.25fr 2fr 2fr 2fr ",
            gridTemplateRows: " repeat(4, 1.0fr)",
            gridTemplateAreas: `
                    "year q1 m1 m2 m3"
                    "year q2 m4 m5 m6"
                    "year q3 m7 m8 m9"
                    "year q4 m10 m11 m12"
                  
                    `,
          }}>
          <button
            onClick={_ => onClick(Year(year))}
            className={[
              `monthview-${Year(year)->entryDateString}`,
              " flex flex-row items-center justify-center",
              hasYearEntry ? `text-lime-500 bg-black` : "text-plain-400 bg-black",
            ]->Array.join(" ")}
            style={{
              gridArea: "year",
            }}>
            <div className="-rotate-90"> {d->DateFns.format("y")->React.string} </div>
          </button>
          <button
            onClick={_ => onClick(Quarter(year, 1))}
            className={[
              `monthview-${Quarter(year, 1)->entryDateString}`,
              " flex flex-row items-center justify-center",
              hasQ1Entry->entryCheck,
            ]->Array.join(" ")}
            style={{
              gridArea: "q1",
            }}>
            <div className=""> {"Q1"->React.string} </div>
            // <Icons.Snowflake />
          </button>
          <button
            onClick={_ => onClick(Quarter(year, 2))}
            className={[
              `monthview-${Quarter(year, 2)->entryDateString}`,
              " flex flex-row items-center justify-center",
              hasQ2Entry->entryCheck,
            ]->Array.join(" ")}
            style={{
              gridArea: "q2",
            }}>
            <div className=""> {"Q2"->React.string} </div>
            // <Icons.Flower />
          </button>
          <button
            onClick={_ => onClick(Quarter(year, 3))}
            className={[
              `monthview-${Quarter(year, 3)->entryDateString}`,
              " flex flex-row items-center justify-center",
              hasQ3Entry->entryCheck,
            ]->Array.join(" ")}
            style={{
              gridArea: "q3",
            }}>
            <div className=""> {"Q3"->React.string} </div>
            // <Icons.Umbrella />
          </button>
          <button
            onClick={_ => onClick(Quarter(year, 4))}
            className={[
              `monthview-${Quarter(year, 4)->entryDateString}`,
              " flex flex-row items-center justify-center",
              hasQ4Entry->entryCheck,
            ]->Array.join(" ")}
            style={{
              gridArea: "q4",
            }}>
            <div className=""> {"Q4"->React.string} </div>
            // <Icons.Leaf />
          </button>
          {Array.make(~length=12, false)
          ->Array.mapWithIndex((_v, i) => {
            let monthNum = (i + 1)->Int.toString
            let monthDate = Date.makeWithYM(~year, ~month=i)
            let hasEntry = dateSet->Set.has(Month(year, i + 1)->entryDateString)

            <button
              key={monthNum}
              onClick={_ => onClick(Month(year, i + 1))}
              className={[
                `monthview-${Month(year, i + 1)->entryDateString}`,
                " flex flex-row items-center justify-center bg-black",
              ]->Array.join(" ")}
              style={{
                gridArea: "m" ++ monthNum,
                color: hasEntry ? monthColor(i + 1) : "inherit",
              }}>
              <div className=""> {monthDate->DateFns.format("MMM")->React.string} </div>
            </button>
          })
          ->React.array}
        </div>
      })
      ->React.array}
    </div>
  }
}

module Day = {
  @react.component
  let make = (~d, ~dateSet, ~onClick, ~hasEntry) => {
    let beginningOfWeek = d->Date.getDay == 0

    let year = d->Date.getFullYear
    let month = d->Date.getMonth + 1
    let monthDay = d->Date.getDate
    let monthColor = monthColor(month)
    let monthColorDim = monthColorDim(month)
    let isToday = DateFns.isSameDay(Date.make(), d)

    <React.Fragment>
      {true && beginningOfWeek
        ? <div className="relative h-0 ml-px">
            <div
              style={{background: monthColor}} className="h-px w-full absolute-translate-y-1/2"
            />
          </div>
        : React.null}
      <div
        className="flex flex-row items-center gap-1 h-6 max-h-6 whitespace-nowrap overflow-x-hidden">
        <div className=" h-6 w-5 flex flex-row flex-none">
          {true && beginningOfWeek
            ? {
                let week = d->DateFns.format("w")

                week
                ->Int.fromString
                ->Option.mapOr(React.null, weekNum => {
                  let hasWeekEntry = dateSet->Set.has(Week(year, weekNum)->entryDateString)

                  <button
                    id={`dayview-${Week(year, weekNum)->entryDateString}`}
                    onClick={_ => onClick(Week(year, weekNum))}
                    style={{
                      color: hasWeekEntry ? monthColor : "#ddd",
                    }}
                    className=" text-left  overflow-visible text-nowrap p-1 font-black">
                    {("" ++ week)->React.string}
                  </button>
                })
              }
            : React.null}
        </div>
        <div
          className={["w-1 h-6 flex-none"]->Array.join(" ")}
          style={{
            backgroundColor: monthColor,
          }}
        />
        <button
          id={`dayview-${Date(year, month, monthDay)->entryDateString}`}
          onClick={_ => onClick(Date(year, month, monthDay))}
          style={{
            color: hasEntry ? monthColor : monthColorDim,
          }}
          className={[
            "font-black px-2 flex-none",
            isToday ? "border-r-4 border-white" : "",
          ]->Array.join(" ")}>
          {d->DateFns.format("y-MM-dd eee")->React.string}
        </button>
        <div className="text-plain-500 flex-none"> {"Singapore"->React.string} </div>
      </div>
    </React.Fragment>
  }

  let make = React.memoCustomCompareProps(make, (a, b) => {
    a.d->Date.getTime == b.d->Date.getTime && a.hasEntry == b.hasEntry
    // false
  })
}

module Days = {
  @react.component
  let make = (~start, ~end, ~dateSet, ~onClick) => {
    <div className="w-full flex-2 overflow-y-scroll text-xs">
      {allDays(start, end)
      ->Array.map(d => {
        <Day
          key={d->Date.toString} d dateSet onClick hasEntry={dateSet->Set.has(d->format("y-MM-dd"))}
        />
      })
      ->React.array}
    </div>
  }

  let make = React.memoCustomCompareProps(make, (a, b) => {
    let dateSetId = x =>
      x
      ->Set.values
      ->Iterator.toArray
      ->Array.toSorted((a, b) => String.localeCompare(a, b))
      ->Array.join("")

    a.start->format("y-MM-dd") == b.start->format("y-MM-dd") &&
    a.end->format("y-MM-dd") == b.end->format("y-MM-dd") &&
    a.dateSet->dateSetId == b.dateSet->dateSetId
  })
}

let entryClassNameId = entryDate => {
  entryDate->Option.mapOr("", date => {
    "entryview-" ++ date->entryDateString
  })
}

module Entry = {
  @react.component
  let make = (
    ~entry,
    ~updateEntry: (string, entry => entry) => unit,
    ~setEntryToSet,
    ~isSelectedForSet,
    ~deleteEntry,
  ) => {
    let monthColor = entry.date->Option.mapOr("#fff", date => {
      switch date {
      | Date(_y, m, _d) => monthColor(m)
      | Month(_y, m) => monthColor(m)
      | Week(y, w) => getMonthForWeekOfYear(w, y)->monthColor
      | _ => "#fff"
      }
    })

    let dateDisplay = entry.date->Option.flatMap(date => {
      switch date {
      | Date(y, m, d) => ymdDate(y, m - 1, d)->format("y-MM-dd eee")->Some
      | x => x->entryDateString->Some
      }
    })

    let goToDay = () =>
      entry.date->Option.mapOr((), entryDate => {
        let dayMatch = switch entryDate {
        | Date(y, m, d) => Date(y, m, d)
        | Week(y, w) => Week(y, w)
        | Year(y) => Date(y, 0, 1)
        | Quarter(y, q) => Date(y, q - 1 * 3, 1)
        | Month(y, m) => Date(y, m, 1)
        }

        `dayview-${dayMatch->entryDateString}`
        ->getElementByIdOp
        ->Option.mapOr((), element => {
          element->scrollIntoView({
            "behavior": "smooth",
            "block": "center",
          })
        })

        let monthMatch = switch entryDate {
        | Date(y, m, _d) => Month(y, m)
        | Week(y, w) => Month(y, getMonthForWeekOfYear(w, y))
        | Year(y) => Year(y)
        | Quarter(y, q) => Quarter(y, q)
        | Month(y, m) => Month(y, m)
        }
        `monthview-${monthMatch->entryDateString}`
        ->getElementByClassOp
        ->Option.mapOr((), element => {
          element->scrollIntoView({
            "behavior": "smooth",
            "block": "center",
          })
        })
      })
    <div key={entry.id}>
      <div
        className={[
          entry.date->entryClassNameId,
          "heading py-2 border-b flex flex-row items-center pr-4",
        ]->Array.join(" ")}
        style={{
          color: monthColor,
          borderColor: monthColor,
        }}>
        {dateDisplay->Option.mapOr(React.null, dateDisplay_ => {
          <span
            className="cursor-pointer mr-2 font-black"
            style={{
              color: isSelectedForSet ? "black" : monthColor,
              backgroundColor: isSelectedForSet ? monthColor : "transparent",
            }}
            onClick={_ => {
              if isSelectedForSet {
                setEntryToSet(_ => None)
              } else {
                goToDay()
              }
            }}>
            {dateDisplay_->React.string}
          </span>
        })}
        <span className=" text-white min-w-8 italic font-light"> {entry.title->React.string} </span>
        <span className="flex-1" />
        <span className="flex flex-row items-center">
          {entry.lock
            ? <button
                className={["mx-1", "bg-black text-plain-500"]->Array.join(" ")}
                onClick={_ => updateEntry(entry.id, v => {...v, lock: false})}>
                <Icons.Lock />
              </button>
            : <React.Fragment>
                <button
                  className={["mx-1 text-black"]->Array.join(" ")}
                  style={{
                    backgroundColor: isSelectedForSet ? monthColor : "white",
                  }}
                  onClick={_ => setEntryToSet(v => v == Some(entry.id) ? None : Some(entry.id))}>
                  {(isSelectedForSet ? "Cancel" : "Set")->React.string}
                </button>
                <button
                  className={["mx-1", "bg-white text-black"]->Array.join(" ")}
                  onClick={_ => deleteEntry(entry.id)}>
                  {"Delete"->React.string}
                </button>
                <button
                  className={["mx-1", " text-plain-500"]->Array.join(" ")}
                  onClick={_ => updateEntry(entry.id, v => {...v, lock: true})}>
                  <Icons.OpenLock />
                  // {"Lock"->React.string}
                </button>
              </React.Fragment>}
        </span>
      </div>
      <div className="py-2">
        <div className="rounded overflow-hidden">
          <Editor
            className={"editor scroll-m-20"}
            content={entry.content}
            onChange={newContent => updateEntry(entry.id, v => {...v, content: newContent})}
            readonly={entry.lock}
          />
        </div>
      </div>
    </div>
  }

  let make = React.memoCustomCompareProps(make, (a, b) => {
    // false
    switch (a.entry.date, b.entry.date) {
    | (Some(x), Some(y)) => x->entryDateString == y->entryDateString
    | (None, None) => true
    | _ => false
    } &&
    a.entry.content == b.entry.content &&
    a.entry.lock == b.entry.lock &&
    a.isSelectedForSet == b.isSelectedForSet
  })
}

module Entries = {
  @react.component
  let make = (
    ~entries: option<array<entry>>,
    ~updateEntry: (string, entry => entry) => unit,
    ~setEntryToSet,
    ~entryToSet,
    ~deleteEntry,
  ) => {
    <div className="text-xs leading-none flex-1 h-full overflow-y-scroll">
      {entries->Option.mapOr(React.null, entries_ => {
        entries_
        ->Array.map(entry => {
          let isSelectedForSet = entryToSet->Option.mapOr(false, v => v == entry.id)

          <Entry key={entry.id} entry updateEntry setEntryToSet isSelectedForSet deleteEntry />
        })
        ->React.array
      })}
    </div>
  }
}

@react.component
let make = () => {
  let (entries, setEntries) = useLocalStorage("data", None)
  let (entryToSet: option<string>, setEntryToSet, getEntryToSet) = useStateWithGetter(() => None)

  let scrollToRef = React.useRef(None)

  React.useEffectOnEveryRender(() => {
    scrollToRef.current
    ->Option.flatMap(x => x->getElementByClassOp)
    ->Option.mapOr((), element => {
      element->scrollIntoView({
        "behavior": "smooth",
        "block": "center",
      })

      scrollToRef.current = None
    })

    None
  })

  let startOfCal = Date.makeWithYMD(~year=2010, ~month=0, ~date=1)
  let endOfCal = Date.makeWithYMD(~year=2030, ~month=0, ~date=1)

  let updateEntry = React.useCallback0((id, f) => {
    setEntries(v =>
      v->Option.map(
        v_ => {
          v_->Array.map(entry => entry.id == id ? f(entry) : entry)
        },
      )
    )
  })

  let sortEntries = data =>
    data->Option.map(v =>
      v->Array.toSorted((a, b) => {
        String.localeCompare(
          a.date->Option.mapOr("", x => x->entryDateString) ++ a.id,
          b.date->Option.mapOr("", x => x->entryDateString) ++ b.id,
        )
      })
    )
  // React.useEffect0(() => {
  //   setImportData(v => v->sortEntries)
  //   None
  // })

  let dateSet =
    entries
    ->Option.getOr([])
    ->Array.map(entry => entry.date)
    ->Array.keepSome
    ->Array.map(date => date->entryDateString)
    ->Set.fromArray

  let makeNewEntry = entryDate => {
    setEntries(v => {
      v
      ->Option.map(entries =>
        Array.concat(
          entries,
          [
            {
              id: (entries->Array.reduce(
                0,
                (a, c) => intMax(a, c.id->Int.fromString->Option.getOr(0)),
              ) + 1)->Int.toString,
              date: entryDate->Some,
              title: "",
              content: "",
              lock: false,
            },
          ],
        )
      )
      ->sortEntries
    })
  }
  let onClickDate = entryDate => {
    getEntryToSet()->Option.mapOr(
      {
        entryDate
        ->Some
        ->entryClassNameId
        ->getElementByClassOp
        ->{
          x =>
            switch x {
            | Some(element) =>
              element->scrollIntoView({
                "behavior": "smooth",
                "block": "center",
              })

            | None => {
                makeNewEntry(entryDate)
                scrollToRef.current = entryDate->Some->entryClassNameId->Some
              }
            }
        }

        switch entryDate {
        | Date(y, _m, _d) => `monthview-${Year(y)->entryDateString}`->getElementByClassOp
        | Week(y, _w) => `monthview-${Year(y)->entryDateString}`->getElementByClassOp
        | Year(y) => `dayview-${Date(y, 1, 1)->entryDateString}`->getElementByIdOp
        | Quarter(y, q) => `dayview-${Date(y, (q - 1) * 3, 1)->entryDateString}`->getElementByIdOp
        | Month(y, m) => `dayview-${Date(y, m, 1)->entryDateString}`->getElementByIdOp
        }->Option.mapOr((), element => {
          element->scrollIntoView({
            "behavior": "smooth",
            "block": "center",
          })
        })
      },
      entryId => {
        updateEntry(entryId, e => {
          ...e,
          date: Some(entryDate),
        })
        setEntryToSet(_ => None)
      },
    )
  }

  <div className="relative font-mono h-dvh flex flex-col">
    <div className="flex flex-row flex-1 overflow-hidden">
      <div className="flex flex-col h-full flex-none w-64 ">
        <Days start={startOfCal} end={endOfCal} dateSet={dateSet} onClick={onClickDate} />
        <Months start={startOfCal} end={endOfCal} dateSet={dateSet} onClick={onClickDate} />
      </div>
      <Entries
        entries={entries}
        updateEntry={updateEntry}
        setEntryToSet
        entryToSet
        deleteEntry={id => {
          setEntries(v => v->Option.map(entries => entries->Array.filter(entry => entry.id != id)))
        }}
      />
    </div>
    <div className="flex-none border-t border-plain-700 flex flex-row gap-2 items-center px-2">
      <button onClick={_ => setEntries(v => v->sortEntries)}> {"Sort"->React.string} </button>
      <button
        onClick={_ =>
          setEntries(v =>
            v->Option.map(entries => entries->Array.map(entry => {...entry, lock: true}))
          )}>
        <Icons.Lock />
      </button>
      <button
        onClick={_ =>
          setEntries(v =>
            v->Option.map(entries => entries->Array.map(entry => {...entry, lock: false}))
          )}>
        <Icons.OpenLock />
      </button>
    </div>
  </div>
}

// let getDate = name => {
//   let date =
//     name
//     ->String.substring(~start=0, ~end=10)
//     ->DateFns.parse("y-MM-dd", 0)

//   date->isInvalidDate
//     ? None
//     : switch (
//         date->DateFns.format("y")->Int.fromString,
//         date->DateFns.format("MM")->Int.fromString,
//         date->DateFns.format("dd")->Int.fromString,
//       ) {
//       | (Some(y), Some(m), Some(d)) => Some(Date(y, m, d))
//       | _ => None
//       }
// }

// React.useEffect0(() => {
//   fetch("../testData/test.json")
//   ->Promise.then(response => {
//     json(response)
//   })
//   ->Promise.then(json => {
//     setImportData(
//       _ => Some(
//         json->Array.mapWithIndex(
//           ((name, content), i) => {
//             id: i->Int.toString,
//             date: getDate(name),
//             title: name,
//             content,
//           },
//         ),
//       ),
//     )
//     Promise.resolve()
//   })
//   ->ignore
//   None
// })
