type entryDate =
  | Year(int)
  | Half(int, int)
  | Quarter(int, int)
  | Month(int, int)
  | Week(int, int)
  | Date(int, int, int)

type entry = {
  id: string,
  date: option<entryDate>,
  title: string,
  content: string,
}

let format = DateFns.format

let ymdDate = (year, month, date) => Date.makeWithYMD(~year, ~month, ~date)

let day_of_ms = 1000 * 60 * 60 * 24

let allDays = (start, end) => {
  let inc = start->Date.getTime->Date.fromTime

  let dayDiff =
    Math.floor((end->Date.getTime -. inc->Date.getTime) /. day_of_ms->Int.toFloat)->Float.toInt
  Array.make(~length=dayDiff, false)->Array.mapWithIndex((_, i) => {
    let result = inc->Date.getTime->Date.fromTime
    inc->Date.setDate(inc->Date.getDate + 1)
    result
  })
}

module Icons = {
  module Flower = {
    @react.component @module("react-icons/lu")
    external make: (~className: string=?, ~style: JsxDOM.style) => React.element = "LuFlower"
  }
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

let monthHue = (monthInt, _) => {
  Float.mod(360. /. 12. *. ((monthInt - 3) * 5)->Int.toFloat, 360.0)
}

let monthColor = (monthInt, year) => {
  hsl(monthHue(monthInt, year), 1.0, 0.7)
}

let monthColorDim = (monthInt, year) => {
  hsl(monthHue(monthInt, year), 1.0, 0.3)
}

module Months = {
  @react.component
  let make = (~start, ~end) => {
    <div className="p-4 bg-black flex-1 overflow-y-scroll flex flex-col gap-2 w-full">
      {allDays(start, end)
      ->Array.map(d => {
        let month = d->DateFns.format("M")->Int.fromString->Option.getOr(0)
        let beginningOfMonth = d->Date.getDate == 1
        let beginningOfYear = d->DateFns.getDayOfYear == 1
        let beginningOfQuarter = mod(month, 3) == 1
        let beginningOfHalf = mod(month, 6) == 1
        let hasYearEntry = Math.random() > 0.7
        let hasH1Entry = Math.random() > 0.7
        let hasH2Entry = Math.random() > 0.7
        let hasQ1Entry = Math.random() > 0.7
        let hasQ2Entry = Math.random() > 0.7
        let hasQ3Entry = Math.random() > 0.7
        let hasQ4Entry = Math.random() > 0.7

        let entryCheck = x => x ? `text-lime-100 bg-lime-900` : "text-neutral-400 bg-black"

        let year = d->Date.getFullYear

        beginningOfMonth
          ? <React.Fragment>
              {beginningOfYear
                ? <div
                    className="gap-px text-xs bg-neutral-800 border border-neutral-600"
                    style={{
                      display: "grid",
                      gridTemplateColumns: "1fr 1.25fr 1.25fr 2fr 2fr 2fr ",
                      gridTemplateRows: " repeat(4, 1.0fr)",
                      gridTemplateAreas: `
                    "year h1 q1 m1 m2 m3"
                    "year h1 q2 m4 m5 m6"
                    "year h2 q3 m7 m8 m9"
                    "year h2 q4 m10 m11 m12"
                  
                    `,
                    }}>
                    <div
                      className={[
                        " flex flex-row items-center justify-center",
                        hasYearEntry->entryCheck,
                      ]->Array.join(" ")}
                      style={{
                        gridArea: "year",
                      }}>
                      <div className="-rotate-90"> {d->DateFns.format("y")->React.string} </div>
                    </div>
                    <div
                      className={[
                        " flex flex-row items-center justify-center",
                        hasH1Entry->entryCheck,
                      ]->Array.join(" ")}
                      style={{
                        gridArea: "h1",
                      }}>
                      <div className=""> {"H1"->React.string} </div>
                    </div>
                    <div
                      className={[
                        " flex flex-row items-center justify-center",
                        hasH2Entry->entryCheck,
                      ]->Array.join(" ")}
                      style={{
                        gridArea: "h2",
                      }}>
                      <div className=""> {"H2"->React.string} </div>
                    </div>
                    <div
                      className={[
                        " flex flex-row items-center justify-center",
                        hasQ1Entry->entryCheck,
                      ]->Array.join(" ")}
                      style={{
                        gridArea: "q1",
                      }}>
                      <div className=""> {"Q1"->React.string} </div>
                    </div>
                    <div
                      className={[
                        " flex flex-row items-center justify-center",
                        hasQ2Entry->entryCheck,
                      ]->Array.join(" ")}
                      style={{
                        gridArea: "q2",
                      }}>
                      <div className=""> {"Q2"->React.string} </div>
                    </div>
                    <div
                      className={[
                        " flex flex-row items-center justify-center",
                        hasQ3Entry->entryCheck,
                      ]->Array.join(" ")}
                      style={{
                        gridArea: "q3",
                      }}>
                      <div className=""> {"Q3"->React.string} </div>
                    </div>
                    <div
                      className={[
                        " flex flex-row items-center justify-center",
                        hasQ4Entry->entryCheck,
                      ]->Array.join(" ")}
                      style={{
                        gridArea: "q4",
                      }}>
                      <div className=""> {"Q4"->React.string} </div>
                    </div>
                    {Array.make(~length=12, false)
                    ->Array.mapWithIndex((v, i) => {
                      let monthNum = (i + 1)->Int.toString
                      let monthColorDim = monthColorDim(i + 1, year)
                      let monthColor = monthColor(i + 1, year)
                      let hasEntry = Math.random() > 0.7
                      let monthDate = Date.makeWithYM(~year, ~month=i)

                      <div
                        className={[
                          " flex flex-row items-center justify-center ",
                          hasEntry->entryCheck,
                        ]->Array.join(" ")}
                        style={{
                          gridArea: "m" ++ monthNum,
                        }}>
                        <div className=""> {monthDate->DateFns.format("MMM")->React.string} </div>
                      </div>
                    })
                    ->React.array}
                  </div>
                : React.null}
            </React.Fragment>
          : React.null
      })
      ->React.array}
    </div>
  }
}

//  {false && beginningOfMonth
//   ? <div
//       style={{color: monthColor}}
//       className="text-left text-xs overflow-visible text-nowrap p-1">
//       {("" ++ d->DateFns.format("MMM"))->React.string}
//     </div>
//   : React.null}
// {false && beginningOfYear
//   ? <div className="text-xs text-white text-left  overflow-visible text-nowrap p-1">
//       {("" ++ d->DateFns.format("y"))->React.string}
//     </div>
//   : React.null}
// {false && month == 3 && monthDay == 1
//   ? <Icons.Flower
//       className="m-1"
//       style={{
//         color: monthColor,
//       }}
//     />
//   : React.null}
//   {false && beginningOfMonth
//     ? <div className="relative h-0 ">
//         <div
//           style={{backgroundColor: monthColor}}
//           className={["h-px w-full -translate-y-1/2"]->Array.join(" ")}
//         />
//       </div>
//     : React.null}
//   {false && beginningOfWeek
//     ? <div className="relative h-0">
//         <div
//           className="text-sm absolute text-neutral-500 bg-black px-4 right-0 -translate-y-1/2 overflow-visible text-nowrap text-end ">
//           {("Week " ++ d->DateFns.format("w"))->React.string}
//         </div>
//       </div>
//     : React.null}
//   {false && beginningOfMonth
//     ? <div className="relative h-0">
//         <div
//           style={{color: monthColor}}
//           className="text-sm absolute  bg-black px-4 right-1/4 -translate-y-1/2 overflow-visible text-nowrap ">
//           {d->DateFns.format("MMMM")->React.string}
//         </div>
//       </div>
//     : React.null}
// <div
//   className={["w-1 h-6 "]->Array.join(" ")}
//   style={{
//     backgroundColor: weekColor(d->DateFns.format("w")->Int.fromString->Option.getOr(0)),
//   }}
// />
module Days = {
  @react.component
  let make = (~start, ~end, ~entries) => {
    let dateSet =
      entries
      ->Option.getOr([])
      ->Array.map(entry => entry.date)
      ->Array.keepSome
      ->Array.map(date =>
        switch date {
        | Date(y, m, d) => ymdDate(y, m - 1, d)->format("y-MM-dd")->Some
        | _ => None
        }
      )
      ->Array.keepSome
      ->Set.fromArray

    <div className="w-full flex-2 p-2 overflow-y-scroll ">
      {allDays(start, end)
      ->Array.map(d => {
        let beginningOfWeek = d->Date.getDay == 0
        let beginningOfMonth = d->Date.getDate == 1
        let beginningOfYear = d->DateFns.getDayOfYear == 1

        let hasEntry = dateSet->Set.has(d->format("y-MM-dd"))

        let year = d->Date.getFullYear
        let month = d->DateFns.format("M")->Int.fromString->Option.getOr(0)
        let monthDay = d->DateFns.format("dd")->Int.fromString->Option.getOr(0)
        let monthColor = monthColor(month, year)
        let monthColorDim = monthColorDim(month, year)
        let isToday = DateFns.isSameDay(Date.make(), d)

        <React.Fragment key={d->format("y-MM-dd")}>
          {true && beginningOfWeek
            ? <div className="relative h-0 ml-px">
                <div
                  style={{background: monthColor}} className="h-px w-full absolute-translate-y-1/2"
                />
              </div>
            : React.null}
          <div
            className="flex flex-row items-center gap-1 text-sm h-6 max-h-6 whitespace-nowrap overflow-x-hidden">
            <div className=" h-6 w-5 flex flex-row flex-none">
              {true && beginningOfWeek
                ? <div
                    className="text-xs text-neutral-200 text-left  overflow-visible text-nowrap p-1">
                    {("" ++ d->DateFns.format("w"))->React.string}
                  </div>
                : React.null}
            </div>
            <div
              className={["w-1 h-6 flex-none"]->Array.join(" ")}
              style={{
                backgroundColor: monthColor,
              }}
            />
            <div
              style={{
                color: hasEntry ? monthColor : monthColorDim,
              }}
              className={["px-2 flex-none", isToday ? "border-r-4 border-white" : ""]->Array.join(
                " ",
              )}>
              {d->DateFns.format("y-MM-dd eee")->React.string}
            </div>
            <div className="text-neutral-500 flex-none"> {"Singapore"->React.string} </div>
          </div>
        </React.Fragment>
      })
      ->React.array}
    </div>
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
  ) => React.element = "default"
}

module TextArea = {
  @react.component
  let make = (~content: string, ~onChange: string => unit) => {
    <TextareaAutosize
      className="bg-black w-full"
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

module Entries = {
  @react.component
  let make = (~entries: option<array<entry>>, ~updateEntry: (string, string) => unit) => {
    <div className="text-xs leading-none flex-1 h-full overflow-y-scroll">
      {entries->Option.mapOr(React.null, entries_ => {
        entries_
        // ->Array.filterWithIndex((_, i) => i > 20 && i < 30)
        ->Array.map(entry => {
          let monthColor = entry.date->Option.mapOr(
            "#fff",
            date => {
              switch date {
              | Date(y, m, d) => monthColor(m, 2000)
              | _ => "#fff"
              }
            },
          )

          let dateDisplay = entry.date->Option.flatMap(
            date => {
              switch date {
              | Date(y, m, d) => ymdDate(y, m - 1, d)->format("y-MM-dd")->Some
              | _ => None
              }
            },
          )

          <div key={entry.id}>
            <div
              className=" py-2 border-b "
              style={{
                color: monthColor,
                borderColor: monthColor,
              }}>
              {dateDisplay->Option.mapOr(
                React.null,
                dateDisplay_ => {
                  <span className="pr-2"> {dateDisplay_->React.string} </span>
                },
              )}
              <span className=" text-white"> {entry.title->React.string} </span>
            </div>
            <div className="py-2">
              <div className="rounded overflow-hidden">
                <Editor
                  content={entry.content} onChange={newValue => updateEntry(entry.id, newValue)}
                />
              </div>
            </div>
          </div>
        })
        ->React.array
      })}
    </div>
  }
}

@react.component
let make = () => {
  let (importData, setImportData) = React.useState(() => None)

  let startOfCal = Date.makeWithYMD(~year=2010, ~month=0, ~date=1)
  let endOfCal = Date.makeWithYMD(~year=2030, ~month=0, ~date=1)

  let getDate = name => {
    let date =
      name
      ->String.substring(~start=0, ~end=10)
      ->DateFns.parse("y-MM-dd", 0)

    date->isInvalidDate
      ? None
      : switch (
          date->DateFns.format("y")->Int.fromString,
          date->DateFns.format("MM")->Int.fromString,
          date->DateFns.format("dd")->Int.fromString,
        ) {
        | (Some(y), Some(m), Some(d)) => Some(Date(y, m, d))
        | _ => None
        }
  }

  React.useEffect0(() => {
    fetch("../testData/test.json")
    ->Promise.then(response => {
      json(response)
    })
    ->Promise.then(json => {
      setImportData(
        _ => Some(
          json->Array.mapWithIndex(
            ((name, content), i) => {
              id: i->Int.toString,
              date: getDate(name),
              title: name,
              content,
            },
          ),
        ),
      )
      Promise.resolve()
    })
    ->ignore
    None
  })

  let showWeekNumber = false
  let showMonthNumber = false

  let updateEntry = (id, newValue) => {
    setImportData(v =>
      v->Option.map(v_ => {
        v_->Array.map(
          entry =>
            entry.id == id
              ? {
                  ...entry,
                  content: newValue,
                }
              : entry,
        )
      })
    )
  }
  <div className="font-mono h-dvh">
    <div className="flex flex-row h-full">
      <div className="flex flex-col h-full flex-none w-64">
        <Days start={startOfCal} end={endOfCal} entries={importData} />
        <Months start={startOfCal} end={endOfCal} />
      </div>
      <Entries entries={importData} updateEntry={updateEntry} />
    </div>
  </div>
}
