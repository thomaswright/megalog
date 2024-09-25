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

let weekColor = weekInt => {
  let weekPercent = weekInt->Int.toFloat /. 53.
  hsv(weekPercent *. 360., 1.0, 1.0)
}

let monthColor = monthInt => {
  let monthPercent = monthInt->Int.toFloat /. 12.
  hsv(monthPercent *. 360., 1.0, 1.0)
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
        <React.Fragment>
          {beginningOfMonth
            ? <div className="relative h-0 ml-4">
                <div className="h-px w-full bg-amber-500 -translate-y-1/2" />
              </div>
            : React.null}
          {beginningOfWeek
            ? <div className="relative h-0 ml-4">
                <div className="h-px w-full bg-neutral-700 -translate-y-1/2" />
              </div>
            : React.null}
          {showWeekNumber && beginningOfWeek
            ? <div className="relative h-0 bg-pink-500">
                <div
                  className="text-sm absolute text-neutral-500 bg-black px-4 right-0 -translate-y-1/2 overflow-visible text-nowrap text-end ">
                  {("Week " ++ d->DateFns.format("w"))->React.string}
                </div>
              </div>
            : React.null}
          {showMonthNumber && beginningOfMonth
            ? <div className="relative h-0 bg-pink-500">
                <div
                  className="text-sm absolute text-amber-500 bg-black px-4 right-1/4 -translate-y-1/2 overflow-visible text-nowrap ">
                  {d->DateFns.format("MMMM")->React.string}
                </div>
              </div>
            : React.null}
          <div className="flex flex-row items-center gap-1">
            <div
              className={["w-1 h-6 "]->Array.join(" ")}
              style={{
                backgroundColor: monthColor(
                  d->DateFns.format("M")->Int.fromString->Option.getOr(0),
                ),
              }}
            />
            <div
              className={["w-1 h-6 "]->Array.join(" ")}
              style={{
                backgroundColor: weekColor(d->DateFns.format("w")->Int.fromString->Option.getOr(0)),
              }}
            />
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
