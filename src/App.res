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

@react.component
let make = () => {
  let showWeekNumber = true
  let showMonthNumber = true
  <div className="p-6 font-mono">
    {allDays()
    ->Array.map(d => {
      let beginningOfWeek = d->Date.getDay == 0
      let beginningOfMonth = d->Date.getDate == 1
      <React.Fragment>
        {beginningOfMonth ? <div className="border border-t border-cyan-900" /> : React.null}
        {beginningOfWeek ? <div className="border border-t border-neutral-900" /> : React.null}
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
                className="text-sm absolute text-cyan-500 bg-black px-4 right-1/4 -translate-y-1/2 overflow-visible text-nowrap ">
                {d->DateFns.format("MMMM")->React.string}
              </div>
            </div>
          : React.null}
        <div className="flex flex-row gap-2 pl-6">
          <div> {d->DateFns.format("y-MM-dd")->React.string} </div>
          <div className="text-neutral-500"> {d->DateFns.format("eee")->React.string} </div>
        </div>
      </React.Fragment>
    })
    ->React.array}
  </div>
}
