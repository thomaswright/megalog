let day_of_ms = 1000 * 60 * 60 * 24

let allDays = () => {
  let start = Date.makeWithYMD(~year=2020, ~month=0, ~date=1)
  let end = Date.makeWithYMD(~year=2025, ~month=0, ~date=1)

  let dayDiff =
    Math.floor((end->Date.getTime -. start->Date.getTime) /. day_of_ms->Int.toFloat)->Float.toInt
  Array.make(~length=dayDiff, false)->Array.mapWithIndex((_, i) => {
    let result = start->Date.getTime->Date.fromTime
    start->Date.setDate(start->Date.getDate + 1)
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
  | 5 => 330.
  | 6 => 180.
  | 7 => 30.
  | 8 => 240.
  | 9 => 90.
  | 10 => 300.
  | 11 => 60.
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
  Float.mod(360. /. 12. *. (monthInt * 7)->Int.toFloat, 360.0)
}

let monthColor = (monthInt, year) => {
  Console.log2(monthInt, monthHue(monthInt, year))
  hsl(monthHue(monthInt, year), 1.0, 0.7)
}

let monthColorDim = (monthInt, year) => {
  hsl(monthHue(monthInt, year), 1.0, 0.3)
}

module Months = {
  @react.component
  let make = () => {
    <div className="p-px bg-black h-fit flex flex-col gap-2">
      {allDays()
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

        let entryCheck = x => x ? `text-black bg-cyan-400` : "text-neutral-200 bg-black"

        let year = d->Date.getFullYear

        beginningOfMonth
          ? <React.Fragment>
              {beginningOfYear
                ? <div
                    className="gap-px text-xs bg-white border border-white"
                    style={{
                      display: "grid",
                      gridTemplateColumns: "1rem 1.25rem 1.25rem 2rem 2rem 2rem ",
                      gridTemplateRows: " repeat(4, 1.0rem)",
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

module Days = {
  @react.component
  let make = () => {
    <div className="w-fit">
      {allDays()
      ->Array.map(d => {
        let beginningOfWeek = d->Date.getDay == 0
        let beginningOfMonth = d->Date.getDate == 1
        let beginningOfYear = d->DateFns.getDayOfYear == 1
        let hasEntry = Math.random() > 0.5
        let year = d->Date.getFullYear
        let month = d->DateFns.format("M")->Int.fromString->Option.getOr(0)
        let monthDay = d->DateFns.format("dd")->Int.fromString->Option.getOr(0)
        let monthColor = monthColor(month, year)
        let monthColorDim = monthColorDim(month, year)
        let isToday = DateFns.isSameDay(Date.make(), d)

        <React.Fragment>
          {true && beginningOfWeek
            ? <div className="relative h-0 ml-px">
                <div
                  style={{background: monthColor}} className="h-px w-full absolute-translate-y-1/2"
                />
              </div>
            : React.null}
          {false && beginningOfMonth
            ? <div className="relative h-0 ">
                <div
                  style={{backgroundColor: monthColor}}
                  className={["h-px w-full -translate-y-1/2"]->Array.join(" ")}
                />
              </div>
            : React.null}
          {false && beginningOfWeek
            ? <div className="relative h-0">
                <div
                  className="text-sm absolute text-neutral-500 bg-black px-4 right-0 -translate-y-1/2 overflow-visible text-nowrap text-end ">
                  {("Week " ++ d->DateFns.format("w"))->React.string}
                </div>
              </div>
            : React.null}
          {false && beginningOfMonth
            ? <div className="relative h-0">
                <div
                  style={{color: monthColor}}
                  className="text-sm absolute  bg-black px-4 right-1/4 -translate-y-1/2 overflow-visible text-nowrap ">
                  {d->DateFns.format("MMMM")->React.string}
                </div>
              </div>
            : React.null}
          <div className="flex flex-row items-center gap-1">
            <div className=" h-6 w-5 flex flex-row">
              {true && beginningOfWeek
                ? <div
                    className="text-xs text-neutral-200 text-left  overflow-visible text-nowrap p-1">
                    {("" ++ d->DateFns.format("w"))->React.string}
                  </div>
                : React.null}
              {false && beginningOfMonth
                ? <div
                    style={{color: monthColor}}
                    className="text-left text-xs overflow-visible text-nowrap p-1">
                    {("" ++ d->DateFns.format("MMM"))->React.string}
                  </div>
                : React.null}
              {false && beginningOfYear
                ? <div className="text-xs text-white text-left  overflow-visible text-nowrap p-1">
                    {("" ++ d->DateFns.format("y"))->React.string}
                  </div>
                : React.null}
              {false && month == 3 && monthDay == 1
                ? <Icons.Flower
                    className="m-1"
                    style={{
                      color: monthColor,
                    }}
                  />
                : React.null}
            </div>
            <div
              className={["w-3 h-6 "]->Array.join(" ")}
              style={{
                backgroundColor: monthColor,
              }}
            />
            // <div
            //   className={["w-1 h-6 "]->Array.join(" ")}
            //   style={{
            //     backgroundColor: weekColor(d->DateFns.format("w")->Int.fromString->Option.getOr(0)),
            //   }}
            // />
            <div
              style={{
                color: hasEntry ? monthColor : monthColorDim,
              }}
              className={["px-2", isToday ? "border-r-4 border-white" : ""]->Array.join(" ")}>
              {d->DateFns.format("y-MM-dd eee")->React.string}
            </div>
            <div className="text-neutral-500"> {"Singapore"->React.string} </div>
          </div>
        </React.Fragment>
      })
      ->React.array}
    </div>
  }
}

@react.component
let make = () => {
  let showWeekNumber = false
  let showMonthNumber = false
  <div className="p-6 font-mono">
    <div className="flex flex-row">
      <Days />
      <Months />
    </div>
  </div>
}
