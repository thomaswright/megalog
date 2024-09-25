let day_of_ms = 1000 * 60 * 60 * 24

let allDays = () => {
  let start = Date.makeWithYMD(~year=2022, ~month=0, ~date=1)
  let end = Date.makeWithYMD(~year=2023, ~month=0, ~date=1)

  let dayDiff =
    Math.floor((end->Date.getTime -. start->Date.getTime) /. day_of_ms->Int.toFloat)->Float.toInt
  Array.make(~length=dayDiff, false)->Array.mapWithIndex((_, i) => {
    let result = start->Date.getTime->Date.fromTime
    start->Date.setDate(start->Date.getDate + 1)
    result
  })
}

let hsv = (h, s, v) => Texel.convert((h, s, v), Texel.okhsv, Texel.srgb)->Texel.rgbToHex

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

let weekColor = weekInt => {
  let weekPercent = weekInt->Int.toFloat /. 53.
  hsv(weekPercent *. 360., 1.0, 1.0)
}

let monthColor = monthInt => {
  let monthPercent = monthInt->Int.toFloat /. 12.
  hsv(
    mod(monthInt, 2) == 0 ? Float.mod(monthPercent *. 360. +. 180., 360.) : monthPercent *. 360.,
    1.0,
    1.0,
  )
}

@react.component
let make = () => {
  let showWeekNumber = true
  let showMonthNumber = true
  <div className="p-6 font-mono">
    <div className="w-96">
      {allDays()
      ->Array.map(d => {
        let beginningOfWeek = d->Date.getDay == 0
        let beginningOfMonth = d->Date.getDate == 1
        let hasEntry = Math.random() > 0.5
        let monthColor = monthColor(d->DateFns.format("M")->Int.fromString->Option.getOr(0))
        <React.Fragment>
          {beginningOfWeek
            ? <div className="relative h-0 ml-4">
                <div className="h-px w-full bg-neutral-700 -translate-y-1/2" />
              </div>
            : React.null}
          {beginningOfMonth
            ? <div className="relative h-0 ">
                <div
                  style={{backgroundColor: monthColor}}
                  className={["h-px w-full -translate-y-1/2"]->Array.join(" ")}
                />
              </div>
            : React.null}
          {showWeekNumber && beginningOfWeek
            ? <div className="relative h-0">
                <div
                  className="text-sm absolute text-neutral-500 bg-black px-4 right-0 -translate-y-1/2 overflow-visible text-nowrap text-end ">
                  {("Week " ++ d->DateFns.format("w"))->React.string}
                </div>
              </div>
            : React.null}
          {showMonthNumber && beginningOfMonth
            ? <div className="relative h-0">
                <div
                  style={{color: monthColor}}
                  className="text-sm absolute  bg-black px-4 right-1/4 -translate-y-1/2 overflow-visible text-nowrap ">
                  {d->DateFns.format("MMMM")->React.string}
                </div>
              </div>
            : React.null}
          <div className="flex flex-row items-center gap-1">
            <div
              className={["w-px h-6 "]->Array.join(" ")}
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
              className={[hasEntry ? "text-neutral-300" : "text-neutral-700", "px-2"]->Array.join(
                " ",
              )}>
              {d->DateFns.format("y-MM-dd eee")->React.string}
            </div>
          </div>
        </React.Fragment>
      })
      ->React.array}
    </div>
  </div>
}
