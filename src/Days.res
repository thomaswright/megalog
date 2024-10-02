module Day = {
  @react.component
  let make = (~d, ~onClick, ~hasWeekEntry, ~entry: option<Entry.entry>) => {
    let beginningOfWeek = d->Date.getDay == 0

    let year = d->Date.getFullYear
    let month = d->Date.getMonth + 1
    let monthDay = d->Date.getDate
    let monthColor = Theme.monthVar(month)
    let monthDimColor = Theme.monthDimVar(month)
    let isToday = DateFns.isSameDay(Date.make(), d)

    <React.Fragment>
      {beginningOfWeek
        ? <div className="relative h-0 ml-px">
            <div
              style={{
                background: monthColor,
              }}
              className="h-px w-full absolute -translate-y-1/2"
            />
          </div>
        : React.null}
      <div
        className="text-xs font-black flex flex-row items-center gap-1 h-5 whitespace-nowrap overflow-x-hidden">
        <div className=" h-full w-5 flex flex-row flex-none items-center">
          {beginningOfWeek
            ? {
                let week = d->DateFns.format("w")

                week
                ->Int.fromString
                ->Option.mapOr(React.null, weekNum => {
                  <button
                    id={`dayview-${Week(year, weekNum)->Entry.entryDateString}`}
                    onClick={_ => onClick(Entry.Week(year, weekNum))}
                    style={{
                      color: hasWeekEntry ? monthColor : "#ccc",
                    }}
                    className="text-left overflow-visible text-nowrap px-1 font-normal">
                    {("" ++ week)->React.string}
                  </button>
                })
              }
            : React.null}
        </div>
        <button
          className="h-full flex-1 flex flex-row items-center whitespace-nowrap overflow-x-hidden"
          onClick={_ => onClick(Date(year, month, monthDay))}
          id={`dayview-${Date(year, month, monthDay)->Entry.entryDateString}`}>
          <span
            className={["w-1 h-full flex-none"]->Array.join(" ")}
            style={{
              background: monthColor,
            }}
          />
          <span
            style={{
              color: entry->Option.isSome ? monthColor : monthDimColor,
            }}
            className={[" px-2 flex-none", isToday ? "border-r-4 border-white" : ""]->Array.join(
              " ",
            )}>
            {d->DateFns.format("y-MM-dd eee")->React.string}
          </span>
          <span className="font-light text-white flex-none italic">
            {entry->Option.mapOr("", e => e.title)->React.string}
          </span>
        </button>
      </div>
    </React.Fragment>
  }

  let make = React.memoCustomCompareProps(make, (a, b) => {
    a.d->Date.getTime == b.d->Date.getTime &&
    switch (a.entry, b.entry) {
    | (Some(ae), Some(be)) => ae.title == be.title
    | (None, None) => true
    | _ => false
    } &&
    a.hasWeekEntry == b.hasWeekEntry
    // false
  })
}

@react.component
let make = (~start, ~end, ~dateSet, ~onClick, ~dateEntries) => {
  <div className="w-full flex-2 overflow-y-scroll text-xs">
    {DateDerived.allDays(start, end)
    ->Array.map(d => {
      <Day
        key={d->Date.toString}
        d
        onClick
        entry={dateEntries->Map.get(d->DateFns.format(Common.standardDateFormat))}
        hasWeekEntry={dateSet->Set.has(d->DateFns.format("y") ++ "-W" ++ d->DateFns.format("w"))}
      />
    })
    ->React.array}
  </div>
}

// let make = React.memoCustomCompareProps(make, (a, b) => {
//   let dateSetId = x =>
//     x
//     ->Set.values
//     ->Iterator.toArray
//     ->Array.toSorted((a, b) => String.localeCompare(a, b))
//     ->Array.join("")

//   a.start->format(standardDateFormat) == b.start->format(standardDateFormat) &&
//   a.end->format(standardDateFormat) == b.end->format(standardDateFormat) &&
//   a.dateSet->dateSetId == b.dateSet->dateSetId
// })
