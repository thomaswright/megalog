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
            {
              let week = d->DateFns.format("w")

              week
              ->Int.fromString
              ->Option.mapOr(React.null, weekNum => {
                <div
                  className="absolute right-0 h-6 sm:h-5 border-l border-b border-r flex flex-row items-center justify-center"
                  style={{borderColor: monthColor}}>
                  <button
                    id={` dayview-${Week(year, weekNum)->Entry.entryDateString}`}
                    onClick={e => onClick(Entry.Week(year, weekNum), e->ReactEvent.Mouse.metaKey)}
                    style={{
                      color: hasWeekEntry ? monthColor : monthDimColor,
                    }}
                    className="text-left overflow-visible text-nowrap px-1 font-black">
                    {("" ++ week)->React.string}
                  </button>
                </div>
              })
            }
          </div>
        : React.null}
      <div
        className=" font-black flex flex-row items-center gap-1 whitespace-nowrap overflow-x-hidden">
        <button
          className={[
            "h-6 sm:h-5 flex-1 flex flex-row items-center whitespace-nowrap overflow-x-hidden",
            isToday ? "bg-[--foreground-200]" : "",
          ]->Array.join(" ")}
          onClick={e => onClick(Date(year, month, monthDay), e->ReactEvent.Mouse.metaKey)}
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
            className={["relative px-2 flex-none"]->Array.join(" ")}>
            {d->DateFns.format("y-MM-dd eee")->React.string}
          </span>
          <span className="font-light text-[--foreground] flex-none italic">
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
  <div className="w-full flex-2 overflow-y-scroll pr-3">
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

let make = React.memoCustomCompareProps(make, (a, b) => {
  let dateSetId = x =>
    x
    ->Set.values
    ->Iterator.toArray
    ->Array.toSorted((a, b) => String.localeCompare(a, b))
    ->Array.join("")

  a.start->DateFns.format(Common.standardDateFormat) ==
    b.start->DateFns.format(Common.standardDateFormat) &&
  a.end->DateFns.format(Common.standardDateFormat) ==
    b.end->DateFns.format(Common.standardDateFormat) &&
  a.dateSet->dateSetId == b.dateSet->dateSetId
})
