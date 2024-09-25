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
  <div className="p-6 font-mono">
    {allDays()
    ->Array.map(d => {
      <div className="flex flex-row gap-2">
        <div> {d->DateFns.format("y-MM-dd")->React.string} </div>
        <div className="text-neutral-500"> {d->DateFns.format("eeee")->React.string} </div>
      </div>
    })
    ->React.array}
  </div>
}
